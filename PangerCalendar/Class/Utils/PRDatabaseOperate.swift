//
//  PRDatabaseOperate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

private let s_Instance: PRDatabaseOperate = PRDatabaseOperate()

class PRDatabaseOperate {
    var db :OpaquePointer? = nil
    
    class func shareMgr() -> PRDatabaseOperate {
        s_Instance.initDB()
        return s_Instance
    }
    
    private func initDB() {
        //打开数据库，指定数据库文件路径，如果文件不存在后先创建文件，再打开，所以无需手动创建文件
        let sqlitepath = Bundle.main.path(forResource: "huangli", ofType: "sqlite")!
        let state = sqlite3_open(sqlitepath, &db)
        if state == SQLITE_OK{
            print("打开数据库成功")
        }else{
            print("打开数据库失败")
        }
    }
    
    private func closeDB() -> Bool {
        let state = sqlite3_close(db)
        if state == SQLITE_OK{
            print("关闭数据库成功")
            return true
        }else{
            print("关闭数据库失败")
            return false
        }
    }
    
    func queryDataWithDate(year: String, month: String, day: String) -> [String: String] {
        var statement:OpaquePointer? = nil
        //查询数据
        let query = "select * from 黄历数据库 where 字段1="+year+" and 字段2="+month+" and 字段3="+day
        //这条执行后，数据就已经在sattement中了
        sqlite3_prepare_v2(db, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW{
            let id4 = sqlite3_column_text(statement, 4)
            var fitThing = ""
            if (id4 != nil) {
                fitThing = String(cString: id4!)
            }
            
            let id5 = sqlite3_column_text(statement, 5)
            var avoidThing = ""
            if id5 != nil {
                avoidThing = String(cString: id5!)
            }
            return ["fit": fitThing, "avoid": avoidThing]
        }
        return ["fit": "", "avoid": ""]
    }
    
    func ReadAllFromDB() -> [String: AnyObject] {
        
        return ["A": "lnj" as AnyObject, "B": "lni" as AnyObject];
    }
}

