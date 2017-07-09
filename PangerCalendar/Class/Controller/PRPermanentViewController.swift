//
//  PRPermanentViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
//import Foundation

class PRPermanentViewController: PRBaseViewController {

    fileprivate var calendarView = PRCalendarView(frame: CGRect(x: 10, y: 64, width: kPRScreenWidth - 20, height: 324))
    fileprivate var dayDetailView = PRDayDetailView(frame: CGRect(x: 0, y: 0, width: kPRScreenWidth, height: 172))
    fileprivate var navigationTitleView = PRCurrentMonthTitleView(frame:CGRect(x: 0, y: 0, width: kPRScreenWidth - 100, height: 44))
   
    fileprivate lazy var datePickerView: PRDatePickView = {
        var pickView = PRDatePickView(frame: UIScreen.main.bounds)
        pickView.datePickDone = { [unowned self] date in
            self.calendarView.selectedDate = date
            self.dayDetailView.update(date: date)
            self.navigationTitleView.update(date: date)
        }
        return pickView
    }()
    
    private lazy var addNoticeVC: PRMissionAddViewController = {
        var tmpAddVC = PRMissionAddViewController()
        return tmpAddVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = NSLocalizedString("日历", comment: "")
        self.resetNavigationTitle()
        /// sqlite
//        let result = PRDatabaseOperate.shareMgr().queryDataWithDate(year: "1991", month: "5", day: "25")
//        print(result["fit"]!, result["avoid"]!)
        self.view.addSubview(self.calendarView)
        self.calendarView.calendarViewDelegate = self
        
        self.view.addSubview(self.dayDetailView)
        self.dayDetailView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(self.view)?.setOffset(0)
            make?.top.equalTo()(self.calendarView.mas_bottom)?.setOffset(0)
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Method
    private func resetNavigationTitle() {
        self.navigationItem.titleView = self.navigationTitleView
        self.navigationTitleView.delegate = self
    
        let addBtn = PRBaseButton()
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addBtn.setImage(PRThemedImage(name:"add_notice_button_nor"), for: .normal)
        addBtn.setImage(PRThemedImage(name:"add_notice_button_sel"), for: .highlighted)
        addBtn.setTitleColor(UIColor.black, for: .normal)
        addBtn.setTitleColor(UIColor.black, for: .highlighted)
        addBtn.addTarget(self, action: #selector(self.addButtonClicked), for: .touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: addBtn)
        self.navigationItem.rightBarButtonItem = btnItem
    }
    
    // MARK: Public Method
    @objc private func addButtonClicked(_ sender: UIButton) {
        self.addNoticeVC.deadlineDate = self.calendarView.selectedDate.defaultMissionTime()
        self.addNoticeVC.dutyPerson = PRUserData.profile
        let navController = PRNavigationController(rootViewController: self.addNoticeVC)
        self.present(navController, animated: true, completion: nil)
    }
    
    // MARK: NSNotification
    func calenderViewChanged(notify: Notification?) {
        UIView.animate(withDuration: 0.2) { 
            
        }
    }
}

extension PRPermanentViewController: PRCalendarViewDelegate {
    func calendarView(aCalendarView: PRCalendarView?, dateChanged: Date?) {
        self.dayDetailView.update(date: dateChanged)
    }
    
    func calendarView(aCalendarView: PRCalendarView?, monthChanged: Date?) {
        self.navigationTitleView.update(date: monthChanged)
    }
    
    func calendarViewFrameChanged(aCalendarView: PRCalendarView?) {
        self.calenderViewChanged(notify: nil)
    }
}


extension PRPermanentViewController: PRCurrentMonthTitleViewDelegate {
    func titleViewClicked() {
        self.datePickerView.show()
    }
    
    func backToToday() {
        let date = Date()
        self.calendarView.selectedDate = date
        self.dayDetailView.update(date: date)
        self.navigationTitleView.update(date: date)
    }
}

