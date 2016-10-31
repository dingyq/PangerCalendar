//
//  PRDBManager.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/31.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation
import FMDB

class PRDatabaseManager: NSObject {
    
    static let manager: PRDatabaseManager = PRDatabaseManager()
    
    override init() {
        super.init()
        openDB()
    }
    
    var db: FMDatabase?
    func openDB() {
        let path = Bundle.main.path(forResource: "huangli", ofType: "sqlite")!
        db = FMDatabase(path: path)
        if !db!.open() {
            print("打开数据库失败")
            return
        }
        
        if !createTable() {
            print("创建数据库失败")
            return
        }
    }
    
    func createTable() -> Bool {
//        // 1.编写SQL语句
//        let sql = "CREATE TABLE IF NOT EXISTS T_Person( \n" +
//            "id INTEGER PRIMARY KEY AUTOINCREMENT, \n" +
//            "name TEXT, \n" +
//            "age INTEGER \n" +
//        ");"
//        // 2.执行SQL语句
//        // 注意: 在FMDB中, 除了查询以外的操作都称之为更新
//        return db!.executeUpdate(sql, withArgumentsIn: nil)
        return false
    }
    
    func queryDataWithDate(year: String, month: String, day: String) -> [[String: String]] {
        //查询数据
        let sql = "select * from 黄历数据库 where 字段1="+year+" and 字段2="+month+" and 字段3="+day

        
        var resultArray: [[String: String]] = []
        if let rs = db?.executeQuery(sql, withArgumentsIn: nil) {
            while rs.next() {
                let id4 = rs.string(forColumnIndex: 4)
                let id5 = rs.string(forColumnIndex: 5)
                let dict = ["fit": id4!, "avoid": id5!]
                resultArray.append(dict as [String: String])
            }
        } else {
            print("select failed: \(db?.lastErrorMessage())")
        }
        return resultArray
    }
    
    
}
