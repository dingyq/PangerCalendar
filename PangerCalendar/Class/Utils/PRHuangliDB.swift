//
//  PRHuangliDB.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRHuangliDB: NSObject {
    static let manager: PRHuangliDB = PRHuangliDB()
    
    private var dbMgr: PRDatabaseManager!
    
    override init() {
        super.init()
        let path = Bundle.main.path(forResource: "huangli", ofType: "sqlite")!
        dbMgr = PRDatabaseManager(path: path)
        self.openDB()
    }
    
    func openDB() {
        let _ = dbMgr.openDB()
    }
    
    func queryDataWithDateInt(year: Int, month: Int, day: Int) -> [[String: String]] {
        return self.queryDataWithDate(year: String.init(format: "%i", year), month: String.init(format: "%i", month), day: String.init(format: "%i", day))
    }
    
    func queryDataWithDate(year: String, month: String, day: String) -> [[String: String]] {
        //查询数据
        let sql = "select * from 黄历数据库 where 字段1="+year+" and 字段2="+month+" and 字段3="+day
        var resultArray: [[String: String]] = []
        if let rs = self.dbMgr.executeQuery(sql) {
            while rs.next() {
                let id4 = rs.string(forColumnIndex: 4)
                var fit = ""
                if id4 != nil {
                    fit = id4!
                }
                let id5 = rs.string(forColumnIndex: 5)
                var avoid = ""
                if id5 != nil {
                    avoid = id5!
                }
                let dict = ["fit": fit, "avoid": avoid]
                resultArray.append(dict as [String: String])
            }
        } else {
            print("select failed: \(self.dbMgr.lastErrorMessage())")
        }
        return resultArray
    }
}
