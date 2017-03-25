//
//  PRPermanentViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
//import Foundation

class PRPermanentViewController: UIViewController, PRCalendarViewDelegate {

    private var calendarView: PRCalendarView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.title = "万年历"
        
        /// sqlite
//        let result = PRDatabaseOperate.shareMgr().queryDataWithDate(year: "1991", month: "5", day: "25")
//        print(result["fit"]!, result["avoid"]!)

        /// fmdb
//        let result1 = PRDatabaseManager.manager.queryDataWithDate(year: "1991", month: "5", day: "25")
//        for dic in result1 {
//            print(dic["fit"]!, dic["avoid"]!)
//        }
//        print(PRChineseFestivalsMgr.shareMgr().festival(month: 5, day: 1))
        
//        ---
        self.calendarView = PRCalendarView(frame: CGRect(x: 10, y: 64, width: 355, height: 300))
        self.calendarView.calendarViewDelegate = self
        self.view.addSubview(self.calendarView)
//        --- 节气公式算法
//        let solarTerms = PRSolarTermsFormulaCompute.shareMgr().calculateSoloarTerms(year: 2016)
//        for solar in solarTerms {
//            print(solar[kSolarTermMonth]!, solar[kSolarTermDay]!)
//        }
    
//        --- 节气查表算法
//        let index: Int = PRSolarTermsMgr.shareMgr().solartermIndex(year: 2050, month: 7, day: 22)
//        print(PRSolarTermsMgr.shareMgr().solartermName(index: index))
        
//        ---
        let lunarMgr = PRLunarDateAlgorithm.shareMgr()
        let lunar = lunarMgr.lunardateFromSolar(year: 1991, month: 5, day: 25)
        print(lunarMgr.lunarDateTianGan(lunarYear: lunar.year), lunarMgr.lunarDateDiZhi(lunarYear: lunar.year), lunarMgr.lunarDateZodiac(lunarYear: lunar.year))
        print(lunarMgr.lunarDateMonth(lunarMonth: lunar.month), lunarMgr.lunarDateDay(lunarDay: lunar.day))
        
//        ---
//        var cLogic1 = PRCalendarLogic().referenceDate
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Protocol Method(PRCalendarViewDelegate)
    func calendarView(aCalendarView: PRCalendarView?, dateChanged: Date?) {
        if dateChanged == nil {
            return
        }
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: dateChanged!)
        let lunarMgr = PRLunarDateAlgorithm.shareMgr()
        let lunar = lunarMgr.lunardateFromSolar(year: components.year!, month: components.month!, day: components.day!)
        NSLog("%@%@ %@年 %@%@",
              lunarMgr.lunarDateTianGan(lunarYear: lunar.year),
              lunarMgr.lunarDateDiZhi(lunarYear: lunar.year),
              lunarMgr.lunarDateZodiac(lunarYear: lunar.year),
              lunarMgr.lunarDateMonth(lunarMonth: lunar.month),
              lunarMgr.lunarDateDay(lunarDay: lunar.day))
    }
    
    func calendarView(aCalendarView: PRCalendarView?, mouthChanged: Date?) {
        
    }

}

//let db = SQLiteDB.sha
