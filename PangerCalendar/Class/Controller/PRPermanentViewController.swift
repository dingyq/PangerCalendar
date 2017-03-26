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
    private var calendarContainer: UIView!
    
    private var dayDetailView: PRDayDetailView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "万年历"
        /// sqlite
//        let result = PRDatabaseOperate.shareMgr().queryDataWithDate(year: "1991", month: "5", day: "25")
//        print(result["fit"]!, result["avoid"]!)
        
        let viewWidth = UIScreen.main.bounds.size.width
        let vFrame = CGRect(x: 0, y: 64, width: viewWidth, height: 325)
//        self.calendarContainer = UIView(frame: vFrame)
//        self.view.addSubview(self.calendarContainer)
        weak var weakSelf = self
//        self.calendarContainer.mas_makeConstraints { (make) in
//            make?.left.right().equalTo()(weakSelf?.view)?.setOffset(0)
//            make?.top.equalTo()(weakSelf?.view)?.setOffset(64)
//            make?.height.setOffset(325)
//        }
        
        self.calendarView = PRCalendarView(frame: CGRect(x: 10, y: 64, width: viewWidth - 20, height: vFrame.size.height-1))
        self.calendarView.calendarViewDelegate = self
        self.view.addSubview(self.calendarView)
//        self.calendarView.mas_makeConstraints { (make) in
//            make?.left.equalTo()(weakSelf?.view)?.setOffset(10)
//            make?.right.equalTo()(weakSelf?.view)?.setOffset(-10)
//            make?.top.equalTo()(weakSelf?.view)?.setOffset(64)
//            make?.height.setOffset(324)
//        }
        
        self.dayDetailView = PRDayDetailView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: 172))
        self.view.addSubview(self.dayDetailView)
        self.dayDetailView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(weakSelf?.view)?.setOffset(0)
            make?.top.equalTo()(weakSelf?.calendarView.mas_bottom)?.setOffset(0)
            make?.height.setOffset(172)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(calenderViewChanged), name: kPRCalenderViewFrameChangedNotify, object: nil)
        
//        --- 节气公式算法
//        let solarTerms = PRSolarTermsFormulaCompute.shareMgr().calculateSoloarTerms(year: 2016)
//        for solar in solarTerms {
//            print(solar[kSolarTermMonth]!, solar[kSolarTermDay]!)
//        }
    
//        --- 节气查表算法
//        let index: Int = PRSolarTermsMgr.shareMgr().solartermIndex(year: 2050, month: 7, day: 22)
//        print(PRSolarTermsMgr.shareMgr().solartermName(index: index))
        
//        ---        
        self.dayDetailView.update(date: self.calendarView.selectedDate)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: NSNotification
    
    func calenderViewChanged(notify: Notification) {
        UIView.animate(withDuration: 0.2) { 
            
        }
    }
    
    // MARK: Protocol Method(PRCalendarViewDelegate)
    func calendarView(aCalendarView: PRCalendarView?, dateChanged: Date?) {
        self.dayDetailView.update(date: dateChanged)
    }
    
    func calendarView(aCalendarView: PRCalendarView?, mouthChanged: Date?) {
    }
}

//let db = SQLiteDB.sha
