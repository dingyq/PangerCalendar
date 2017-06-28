//
//  PRMissonsData.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissonsData: NSObject {
    static let manager: PRMissonsData = PRMissonsData()
    private var userInfoDBMgr: PRUserInfoDB!
    
    private var primaryKey: String!
    private var tableName: String!
    private var tableColumn: NSDictionary!
    private var columnType: NSDictionary!
    
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "PRMissonNoticeTable", ofType: "plist")
        if path != nil {
            let configDic = NSDictionary(contentsOfFile: path!)
            self.primaryKey = configDic?.value(forKey: "PrimaryKey") as? String
            self.tableName = configDic?.value(forKey: "TableName") as? String
            self.tableColumn = configDic?.value(forKey: "OCType") as? NSDictionary
            self.columnType = configDic?.value(forKey: "DBType") as? NSDictionary
        }
        self.userInfoDBMgr = PRUserInfoDB()
    }
    
    func clearAllData() {
        let _ = self.userInfoDBMgr.eraseData(self.tableName)
    }
    
    func insertData(valueDic: NSDictionary) {
        let _ = self.userInfoDBMgr.insertData(self.tableName, columnDic: self.tableColumn, columnTypeDic: self.columnType, valueDic: valueDic)
    }
    
    func deleteData(valueDic: NSDictionary) {
        let _ = self.userInfoDBMgr.deleteData(self.tableName, key: self.primaryKey, value: valueDic.value(forKey: self.primaryKey) as! Int)
    }
    
}
