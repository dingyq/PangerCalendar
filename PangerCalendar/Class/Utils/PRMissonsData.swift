//
//  PRMissionsData.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

let PRMissionsDataMgr = PRMissionsData()

fileprivate let kPageSize = 10

class PRMissionsData: NSObject {

    private var primaryKey: String
    private var tableName: String
    private var ocType: NSDictionary
    private var dbType: NSDictionary
    
    override init() {
        let path = Bundle.main.path(forResource: "PRMissionNoticeTable", ofType: "plist")
        assert(path != nil, "缺失配置文件: PRMissionNoticeTable.plist")
        let configDic = NSDictionary(contentsOfFile: path!)
        primaryKey = configDic!.value(forKey: "PrimaryKey") as! String
        tableName = configDic!.value(forKey: "TableName") as! String
        ocType = configDic!.value(forKey: "OCType") as! NSDictionary
        dbType = configDic!.value(forKey: "DBType") as! NSDictionary
        super.init()
        let _ = self.createTable()
    }
    
    func clearAllData() {
        let _ = PRUserInfoDBMgr!.eraseTable(self.tableName)
    }
    
    func insertData(valueDic: NSDictionary) {
        let _ = PRUserInfoDBMgr!.insertData(self.tableName, dbTypeDic: self.dbType, ocTypeDic: self.ocType, valueDic: valueDic)
    }
    
    func deleteData(valueDic: NSDictionary) {
        let _ = PRUserInfoDBMgr!.deleteData(self.tableName, key: self.primaryKey, value: valueDic.value(forKey: self.primaryKey) as! Int)
    }
  
    func updateData(valueDic: NSDictionary, primaryKey: String) {
        let _ = PRUserInfoDBMgr!.updateData(self.tableName, valueDic: valueDic, primaryKey: primaryKey)
    }
    
    func queryData(missionId: Int) -> Array<NSDictionary>? {
        let dic = [self.primaryKey: NSNumber(value: missionId)]
        return PRUserInfoDBMgr!.queryTable(self.tableName, paramDic: dic as NSDictionary)
    }
    
    func moreData(sortId: Int?) -> Array<NSDictionary> {
        let tableStr = self.tableName
        var sql = "select * from \(tableStr)"
        if (sortId != nil && sortId != 0) {
            sql = "select * from \(tableStr) where sortId < \(sortId!) order by sortId desc LIMIT \(kPageSize)"
        } else {
            sql = "select * from \(tableStr) order by sortId desc LIMIT \(kPageSize)"
        }
        return PRUserInfoDBMgr!.queryTableWithCustomSql(sql: sql)
    }
    
    func dataSortByDeadlineTime() -> Array<NSDictionary>? {
        return nil
    }
    
    func dataSortByCompleteTime() -> Array<NSDictionary>? {
        return nil
    }
    
    func deleteData(dataArr: Array<NSDictionary>) {
        for tmpDic in dataArr {
            let queryArr = self.queryData(missionId: tmpDic[self.primaryKey] as! Int)
            if ((queryArr?.count)! > 0) {
                self.deleteData(valueDic: tmpDic)
            }
        }
    }
    
    func syncData(dataArr: Array<NSDictionary>) {
        for index in 0..<dataArr.count {
            let tmpDic = dataArr[index]
            let typeKeyArr = self.ocType.allKeys
            var dict: Dictionary<String, AnyObject> = [:]
            for key in typeKeyArr {
                let keyStr = key as! String
                var tmpObj = tmpDic.value(forKey: keyStr)
                if tmpObj == nil {
                    if ((self.ocType.value(forKey: keyStr) as! NSString).isEqual(to: "NSString")) {
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
        if (PRUserInfoDBMgr!.isTableExist(self.tableName)) {
            print("Table \(self.tableName) already exist")
            return false
        } else {
            return (PRUserInfoDBMgr!.createTable(self.tableName, dbTypeDic: self.dbType))
        }
    }
    
    
}
