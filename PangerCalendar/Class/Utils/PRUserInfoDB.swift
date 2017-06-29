//
//  PRUserInfoDB.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/28.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

let PRUserInfoDBMgr = PRUserInfoDB().manager

class PRUserInfoDB: NSObject {
    var manager: PRDatabaseManager!
    private var dbPath: String!
    
    override init() {
        super.init()
        self.dbPath = kPathOfDocument.appendingPathComponent(path: "PRUserInfoDB.sqlite")
        self.manager = PRDatabaseManager(path: self.dbPath)
        let _ = self.manager.openDB()
    }
    
}
