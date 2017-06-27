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
    
    override init() {
        super.init()
    }
    
    private var db: FMDatabase?
    func openDB(path: String) -> Bool {
        db = FMDatabase(path: path)
        if !db!.open() {
            print("打开数据库失败")
            return false
        }
        
        if !createTable() {

        }
        return true
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
    
    func executeQuery(_ sql: String) -> FMResultSet? {
        return db?.executeQuery(sql, withArgumentsIn: nil)
    }
    
    func lastErrorMessage() -> String {
        return db?.lastErrorMessage() ?? ""
    }
}
