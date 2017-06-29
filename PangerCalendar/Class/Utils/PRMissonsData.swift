//
//  PRMissonsData.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

let PRMissonsDataMgr = PRMissonsData()

fileprivate let kPageSize = 10

class PRMissonsData: NSObject {

    private var primaryKey: String!
    private var tableName: String!
    private var ocType: NSDictionary!
    private var dbType: NSDictionary!
    
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "PRMissonNoticeTable", ofType: "plist")
        if path != nil {
            let configDic = NSDictionary(contentsOfFile: path!)
            self.primaryKey = configDic?.value(forKey: "PrimaryKey") as? String
            self.tableName = configDic?.value(forKey: "TableName") as? String
            self.ocType = configDic?.value(forKey: "OCType") as? NSDictionary
            self.dbType = configDic?.value(forKey: "DBType") as? NSDictionary
        }
        let _ = self.createTable()
    }
    
    func clearAllData() {
        let _ = PRUserInfoDBMgr?.eraseTable(self.tableName)
    }
    
    func insertData(valueDic: NSDictionary) {
        let _ = PRUserInfoDBMgr?.insertData(self.tableName, columnDic: self.ocType, columnTypeDic: self.dbType, valueDic: valueDic)
    }
    
    func deleteData(valueDic: NSDictionary) {
        let _ = PRUserInfoDBMgr?.deleteData(self.tableName, key: self.primaryKey, value: valueDic.value(forKey: self.primaryKey) as! Int)
    }
  
    func updateData(valueDic: NSDictionary, primaryKey: String) {
        let _ = PRUserInfoDBMgr?.updateData(self.tableName, valueDic: valueDic, primaryKey: primaryKey)
    }
    
    func queryData(missionId: Int) -> Array<NSDictionary>? {
        let dic = [self.primaryKey: NSNumber(value: missionId)]
        return PRUserInfoDBMgr?.queryTable(self.tableName, paramDic: dic as NSDictionary)
    }
    
    func getLatestData(sortId: Int) -> Array<NSDictionary>? {
        var sql = "select * from \(self.tableName) where sortId < \(sortId) order by sortId desc LIMIT \(kPageSize)"
        if sortId == 0 {
            sql = "select * from \(self.tableName) order by sortId desc LIMIT \(kPageSize)"
        }
        return PRUserInfoDBMgr?.queryTableWithCustomSql(sql: sql)
    }
    
    func deleteData(dataArr: Array<NSDictionary>) {
        for tmpDic in dataArr {
            let queryArr = self.queryData(missionId: tmpDic[self.primaryKey] as! Int)
            if ((queryArr?.count)! > 0) {
                self.deleteData(valueDic: tmpDic)
            }
        }
    }
    
    func syncDataToDB(dataArr: Array<NSDictionary>) {
        for index in 0..<dataArr.count {
            let tmpDic = dataArr[index]
            let typeKeyArr = self.dbType.allKeys
            var dict: Dictionary<String, AnyObject> = [:]
            for key in typeKeyArr {
                let keyStr = key as! String
                var tmpObj = tmpDic.value(forKey: keyStr)
                if tmpObj == nil {
                    if ((self.dbType.value(forKey: keyStr) as! NSString).isEqual(to: "NSString")) {
                        tmpObj = ""
                    } else {
                        tmpObj = NSNumber(value: 0)
                    }
                }
                dict[keyStr] = tmpObj as AnyObject
            }

            let queryArr = self.queryData(missionId: tmpDic[self.primaryKey] as! Int)
            if (queryArr?.count)! > 0 {
                self.updateData(valueDic: dict as NSDictionary, primaryKey: self.primaryKey)
            } else {
                self.insertData(valueDic: dict as NSDictionary)
            }
        }
    }
    
    func createTable() -> Bool {
        if (PRUserInfoDBMgr?.isTableExist(self.tableName))! {
            print("Table \(self.tableName) already exist")
            return false
        } else {
            return (PRUserInfoDBMgr?.createTable(self.tableName, columnDic: self.ocType))!
        }
    }
    
    
}
