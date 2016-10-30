//
//  ViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
//import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("test")
//        let sqlitePath = NSHomeDirectory() + "/Resource/huangli.mdb"
//        print(sqlitePath)
//        var db :OpaquePointer? = nil
        //数据库存放路径
//        let sqlitepath = NSHomeDirectory().stringByAppendingPathComponent("Documents/sqlite3.db")
        PRDatabaseOperate.shareMgr().testDB()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//let db = SQLiteDB.sha
