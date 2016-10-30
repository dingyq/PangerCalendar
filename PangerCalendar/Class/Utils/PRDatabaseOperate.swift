//
//  PRDatabaseOperate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit

private let s_Instance: PRDatabaseOperate = PRDatabaseOperate()

class PRDatabaseOperate {
    var db :OpaquePointer? = nil
    
    class func shareMgr() -> PRDatabaseOperate {
        return s_Instance
    }
    
    func testDB() -> () {
        //打开数据库，指定数据库文件路径，如果文件不存在后先创建文件，再打开，所以无需手动创建文件
        let sqlitepath = Bundle.main.path(forResource: "huangli", ofType: "sqlite")!
        print(sqlitepath)
        let state = sqlite3_open(sqlitepath, &db)
        if state == SQLITE_OK{
            print("打开数据库成功")
        }else{
            print("打开数据库失败")
        }
        
        var statement:OpaquePointer? = nil
        //查询数据
        let query = "select * from 黄历数据库"
        //这条执行后，数据就已经在sattement中了
        sqlite3_prepare_v2(db, query, -1, &statement, nil)
        while sqlite3_step(statement) == SQLITE_ROW{
            let id = sqlite3_column_int(statement, 0)
            let id1 = sqlite3_column_int(statement, 1)
            let id2 = sqlite3_column_int(statement, 2)
            let id3 = sqlite3_column_int(statement, 3)
        
            let tmp1 = sqlite3_column_text(statement, 4)
            
            var id4 = ""
            if (tmp1 != nil) {
                id4 = String(cString: tmp1!)
            }
            
            let tmp2 = sqlite3_column_text(statement, 5)
            var id5 = ""
            if tmp2 != nil {
                id5 = String(cString: tmp2!)
            }
            
            print(id, id1, id2, id3, id4, id5 )
        }
    }
    
    func ReadAllFromDB() -> [String: AnyObject] {
        
        return ["A": "lnj" as AnyObject, "B": "lni" as AnyObject];
    }
}

