//
//  PRPermanentViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
//import Foundation

class PRPermanentViewController: PRBaseViewController, PRCalendarViewDelegate, PRCurrentMonthTitleViewDelegate, PRDatePickViewDelegate {

    private var calendarView: PRCalendarView!
    private var calendarContainer: UIView!
    private var dayDetailView: PRDayDetailView!
    private var navigationTitleView: PRCurrentMonthTitleView!
    private var datePickerView: PRDatePickView!
    private lazy var addNoticeVC: PRNoticeAddViewController = {
        var tmpAddVC: PRNoticeAddViewController = PRNoticeAddViewController()
        return tmpAddVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "万年历"
        self.resetNavigationItem()
        //        self.navigationController?.navigationItem.titleView = PRCurrentMonthTitleView()
        
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
        
//        NotificationCenter.default.addObserver(self, selector: #selector(calenderViewChanged), name: kPRCalenderViewFrameChangedNotify, object: nil)
        
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
        self.navigationTitleView.update(date: self.calendarView.selectedDate)
        
        
        self.datePickerView = PRDatePickView(frame: UIScreen.main.bounds)
        self.datePickerView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Method
    private func resetNavigationItem() {
        let width = UIScreen.main.bounds.size.width - 100
        self.navigationTitleView = PRCurrentMonthTitleView(frame:CGRect(x: 0, y: 0, width: width, height: 44))
        self.navigationItem.titleView = self.navigationTitleView
        self.navigationTitleView.delegate = self
    
        let addBtn = UIButton()
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addBtn.setImage(UIImage(named:"add_notice_button"), for: .normal)
        addBtn.setImage(UIImage(named:"add_notice_button"), for: .highlighted)
        addBtn.setTitleColor(UIColor.black, for: .normal)
        addBtn.setTitleColor(UIColor.black, for: .highlighted)
        addBtn.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: addBtn)
        self.navigationItem.rightBarButtonItem = btnItem
    }
    
    // MARK: Public Method
    func addButtonClicked(sender: UIButton) {
        let navController = PRNavigationController(rootViewController: self.addNoticeVC)
        self.present(navController, animated: false, completion: nil)
    }
    
    // MARK: NSNotification
    func calenderViewChanged(notify: Notification?) {
        UIView.animate(withDuration: 0.2) { 
            
        }
    }
    
    // MARK: Protocol Method(PRCalendarViewDelegate)
    func calendarView(aCalendarView: PRCalendarView?, dateChanged: Date?) {
        self.dayDetailView.update(date: dateChanged)
    }
    
    func calendarView(aCalendarView: PRCalendarView?, monthChanged: Date?) {
        self.navigationTitleView.update(date: monthChanged)
        
    }
    
    func calendarViewFrameChanged(aCalendarView: PRCalendarView?) {
        self.calenderViewChanged(notify: nil)
    }
    
    // MARK: Protocol Method(PRCurrentMonthTitleViewDelegate)
    func titleViewClicked() {
        self.datePickerView.show()
    }
    
    func resetToDate(date: Date) {
        self.calendarView.selectedDate = date
        self.dayDetailView.update(date: date)
        self.navigationTitleView.update(date: date)
    }
    
    // MARK: Protocol Method(PRDatePickViewDelegate)
    func datePickDone(date: Date) {
        self.calendarView.selectedDate = date
        self.dayDetailView.update(date: date)
        self.navigationTitleView.update(date: date)
    }
}

//let db = SQLiteDB.sha
