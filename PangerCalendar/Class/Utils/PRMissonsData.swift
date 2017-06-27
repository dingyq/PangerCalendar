//
//  PRMissonsData.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissonsData: NSObject {
    static let manager: PRHuangliData = PRHuangliData()
    
    private var dbMgr: PRDatabaseManager!
    
    override init() {
        super.init()
        dbMgr = PRDatabaseManager()
        openDB()
    }
    
    func openDB() {
        let path = Bundle.main.path(forResource: "huangli", ofType: "sqlite")!
        let result = dbMgr.openDB(path: path)
        if result {
            
        }
    }
}
