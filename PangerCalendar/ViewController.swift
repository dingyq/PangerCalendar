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
//        let result = PRDatabaseOperate.shareMgr().queryDataWithDate(year: "1991", month: "5", day: "25")
//        print(result["fit"]!, result["avoid"]!)
//        
//        let result1 = PRDatabaseManager.manager.queryDataWithDate(year: "1991", month: "5", day: "26")
//        for dic in result1 {
//            print(dic["fit"]!, dic["avoid"]!)
//        }
       print(PRChineseFestivals.shareMgr().festival(month: 5, day: 1))
        
        self.view.addSubview(PRCalendarView(frame: CGRect(x: 0, y: 0, width: 100, height: 100)))
        
        let solarTerms = PRSolarTermsFormulaCompute.shareMgr().calculateSoloarTerms(year: 2016)
        for solar in solarTerms {
            print(solar[kSolarTermMonth]!, solar[kSolarTermDay]!)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//let db = SQLiteDB.sha
