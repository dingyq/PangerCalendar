//
//  PRDBManager.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/31.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation
//import FMDB

class PRDatabaseManager: NSObject {
    
    private var db: FMDatabase?
    private var dbPath: String?
    
    init(path: String) {
        self.dbPath = path
        self.db = FMDatabase(path: path)
    }
    
    override init() {
        super.init()
    }
    
    func openDB() -> Bool {
        if !self.db!.open() {
            assert(false, "数据库打开失败: \(self.dbPath ?? "")")
            return false
        }
        self.db?.setShouldCacheStatements(true)
        return true
    }
    
    func closeDB() -> Bool {
        self.db?.close()
        return true
    }
    

    func executeQuery(_ sql: String) -> FMResultSet? {
        return self.db?.executeQuery(sql, withArgumentsIn: nil)
    }
    
    func lastErrorMessage() -> String {
        return self.db?.lastErrorMessage() ?? ""
    }

    func deleteDB(path: String) {
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: path) {
            self.db?.close()
            do {
                try fileManager.removeItem(atPath: path)
            } catch {
                assert(false, "删除数据库失败: \(path)")
            }
        }
    }
    
    func isTableExist(_ name: String) -> Bool {
        let rs = self.executeQuery("SELECT count(*) as 'count' FROM sqlite_master WHERE type ='table' and name = \(name)")
        while (rs?.next())! {
            let count = rs?.int(forColumn: "count")
            print("isTableOK \(count ?? 0)")
            if count! > 0 {
                return true
            }
        }
        return false
    }
    
    func createTable(_ name: String, columnDic: NSDictionary) -> Bool {
        let arguments = self.generateCreateTableSqlArguments(columnDic: columnDic)
        let sqlStr = "CREATE TABLE \(name) \(arguments)"
        if (self.db?.executeUpdate(sqlStr, withArgumentsIn: nil))! {
            return true
        }
        assert(false, "创建表 \(name)失败")
        return false
    }
    
    func deleteTable(_ name: String) -> Bool {
        let sqlStr = "DROP TABLE \(name)"
        if (self.db?.executeUpdate(sqlStr, withArgumentsIn: nil))! {
            return true
        }
        assert(false, "删除表 \(name)失败")
        return false
    }
    
    func eraseTable(_ name: String) -> Bool {
        let sqlStr = "DELETE FROM \(name)"
        if (self.db?.executeUpdate(sqlStr, withArgumentsIn: nil))! {
            return true
        }
        assert(false, "清理表 \(name)失败")
        return false
    }
    
    func queryTable(_ name: String, paramDic: NSDictionary) -> Array<NSDictionary> {
        var result = Array<NSDictionary>()
        let keys = paramDic.allKeys
        if keys.count == 0 {
            return []
        }
        let keyStr = keys.first as! String
        let value = paramDic.value(forKey: keyStr)
        let sqlStr = "select * from \(name) where \(keyStr) = \(value ?? "")"
        let rs = self.executeQuery(sqlStr)
        while (rs?.next())! {
            let tmp = rs?.resultDictionary()
            if tmp != nil {
                result.append(tmp! as NSDictionary)
            }
        }
        return result
    }
    
    func queryTable(_ name: String) -> Array<NSDictionary> {
        var result = Array<NSDictionary>()
        let sqlStr = "select * from \(name)"
        let rs = self.executeQuery(sqlStr)
        while (rs?.next())! {
            let tmp = rs?.resultDictionary()
            if tmp != nil {
                result.append(tmp! as NSDictionary)
            }
        }
        return result
    }
    
    
    func queryTableWithCustomSql(sql: String) -> Array<NSDictionary> {
        var result = Array<NSDictionary>()
        let rs = self.executeQuery(sql)
        while (rs?.next())! {
            let tmp = rs?.resultDictionary()
            if tmp != nil {
                result.append(tmp! as NSDictionary)
            }
        }
//        for dic in result {
//            var tmpStr = ""
//            let keys = dic.allKeys
//            for key in keys {
//                let tmp = dic.value(forKey: key as! String)
//                tmpStr.append("\(key) = \(tmp ?? "")")
//            }
//            print(tmpStr)
//        }
        return result
    }
    
    func insertData(_ tableName: String, columnDic: NSDictionary, columnTypeDic:NSDictionary, valueDic:NSDictionary) -> Bool {
        if self.isTableExist(tableName) {
            let _ = self.createTable(tableName, columnDic: columnDic)
        }
        let sql = self.generateInsertTableDataSql(tableName, columnDic: columnDic)
        var argsArr = Array<Any>()
        // 字段补齐
        let typeKeys = columnTypeDic.allKeys
        for key in typeKeys {
            let keyStr = key as! String
            var tmpObj = valueDic.value(forKey: keyStr)
            if tmpObj == nil {
                if ((columnTypeDic.value(forKey:keyStr) as! NSString).isEqual(to: "NSString")) {
                    tmpObj = ""
                } else {
                    tmpObj = NSNumber(value: 0)
                }
            }
            argsArr.append(tmpObj!)
        }
        let result = self.db?.executeUpdate(sql, withArgumentsIn: argsArr)
        assert(result!, "插入数据 \(tableName)失败")
        return result!
    }
    
    func insertData(sql: String, argsDic: NSDictionary) -> Bool {
        let result = self.db?.executeUpdate(sql, withParameterDictionary: argsDic as! [AnyHashable : Any])
        return result!
    }
    
    func insertData(sql: String, argsArr: Array<Any>) -> Bool {
        let result = self.db?.executeUpdate(sql, withArgumentsIn: argsArr)
        return result!
    }
    
    func updateData(_ tableName: String, valueDic: NSDictionary, primaryKey: String) -> Bool {
        let sqlStr = NSMutableString(string: "UPDATE \(tableName) SET ")
        let keys = valueDic.allKeys
        for index in 0..<keys.count {
            let keyStr = keys[index] as! String
            let valueStr = valueDic.value(forKey: keyStr)!
            sqlStr.append("\(keyStr) = '\(valueStr)'")
        }
        sqlStr.deleteCharacters(in: NSMakeRange(sqlStr.length - 2, 2))
        let primaryValue = valueDic.value(forKey: primaryKey)!
        sqlStr.append(" WHERE \(primaryKey) = '\(primaryValue)'")
        
        let result = self.db?.executeUpdate(sqlStr as String!, withArgumentsIn: nil)
        assert(result!, "更新数据 \(tableName)失败")
        return result!
    }
    
    func deleteData(_ tableName: String, key: String, value: Int) -> Bool {
        let sql = "DELETE FROM \(tableName) WHERE \(key) = '\(value)'"
        let result = self.db?.executeUpdate(sql, withArgumentsIn: nil)
        assert(result!, "删除数据 \(tableName)失败")
        return result!
    }
    
    func multiThread(sql: String, argsArr: Array<Any>) {
        // TODO:
        
    }
    
    private func generateCreateTableSqlArguments(columnDic: NSDictionary) -> String {
        let keys = columnDic.allKeys
        let arguments = NSMutableString(string: "'id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ,")
        for key in keys {
            arguments.append("'\(key)' \(columnDic.value(forKey: key as! String)!), ")
        }
        arguments.deleteCharacters(in: NSMakeRange(arguments.length - 2, 2))
        return arguments as String
    }
    
    private func generateInsertTableDataSql(_ name:String, columnDic: NSDictionary) -> String {
        let keys = columnDic.allKeys
        let columnStr = NSMutableString()
        let valueStr = NSMutableString()
        for key in keys {
            columnStr.append("\(key), ")
            valueStr.append(":\(key), ")
        }
        columnStr.deleteCharacters(in: NSMakeRange(columnStr.length - 2, 2))
        valueStr.deleteCharacters(in: NSMakeRange(valueStr.length - 2, 2))
        let sqlStr = "INSERT INTO \(name) (\(columnStr)) VALUES (\(valueStr))"
        return sqlStr
    }
    
}
