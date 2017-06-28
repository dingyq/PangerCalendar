//
//  PRUserInfoDB.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/28.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit


class PRUserInfoDB: NSObject {
    static let manager: PRUserInfoDB = PRUserInfoDB()
    
    private var dbMgr: PRDatabaseManager!
    private var dbPath: String!
    
    override init() {
        super.init()
        self.dbPath = kPathOfDocument.appendingPathComponent(path: "PRUserInfoDB.sqlite")
        self.dbMgr = PRDatabaseManager(path: self.dbPath)
        self.openDB()
    }
    
    func openDB() {
        let _ = self.dbMgr.openDB()
    }
    
    func closeDB() {
        let _ = self.dbMgr.closeDB()
    }
    
    func eraseData(_ name: String) -> Bool {
        return self.dbMgr.eraseTable(name)
    }
    
    func insertData(_ name: String, columnDic: NSDictionary, columnTypeDic: NSDictionary, valueDic: NSDictionary) -> Bool {
        return self.dbMgr.insertData(name, columnDic: columnDic, columnTypeDic: columnTypeDic, valueDic: valueDic)
    }
    
    func deleteData(_ name: String, key: String, value: Int) -> Bool {
        return self.dbMgr.deleteData(name, key: key, value: value)
    }
    
}
