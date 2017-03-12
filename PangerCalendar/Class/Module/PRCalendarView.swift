//
//  PRCalendarView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/10.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit

class PRCalendarView: UIView, PRCalendarLogicDelegate, UIGestureRecognizerDelegate {
    
    // MARK: Public Ivars
    var calendarViewDelegate: PRCalendarViewDelegate?
    var calendarViewScrollDelegate: PRCalendarViewScrollDelegate?
    
    var selectedDate: Date! {
        set(newDate) {
            _selectedDate = newDate
            self.calendarLogic.referenceDate = newDate
            self.calendarMonth.selectButton(date: newDate)
        }
        get {
            return _selectedDate
        }
    }
    
    private var _selectedDate: Date?
    private var calendarLogic: PRCalendarLogic!
    private var calendarMonth: PRCalendarMonth!
    private var calendarMonthNew: PRCalendarMonth?
    private var leftBtn: UIButton?
    private var rightBtn: UIButton?
    private var calendarMonthFrame: CGRect!
    
    /// //翻页滚动是否完成
    private var isViewLoaded: Bool!
    /// //移动收拾移动速度
    private var panVelocity: CGPoint?
    
    /// //移动手势上一次的位置
    private var handlePanLastLocation: CGPoint?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        self.backgroundColor = UIColor.red
        self.frame = frame
        self.clearsContextBeforeDrawing = false
        self.isOpaque = true
        self.clipsToBounds = true
        
        self.calendarViewDelegate = nil
        
        // 默认选中今天
        _selectedDate = PRCalendarLogic.dateForToday()
        
        self.calendarLogic = PRCalendarLogic(delegate: self, aDate: self.selectedDate!)
        // 创建日历的一个月历视图，指定范围和日期逻辑
        self.calendarMonthFrame = CGRect.init(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height);
        
        self.calendarMonth = PRCalendarMonth(frame: self.calendarMonthFrame, logic: self.calendarLogic)
        self.calendarMonth.selectButton(date: self.selectedDate)
        self.addSubview(self.calendarMonth)
        self.isViewLoaded = true
        
        let panGestureRecognizer: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanFrom))
        panGestureRecognizer.delegate = self
        self.addGestureRecognizer(panGestureRecognizer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private Method
    
    func handlePanFrom(recognizer: UIPanGestureRecognizer) {
        let location:CGPoint = recognizer.location(in: self)
        if recognizer.state == UIGestureRecognizerState.ended {
            if !self.isViewLoaded {
                return
            }
            self.isViewLoaded = false
            // 速度
            self.panVelocity = recognizer.velocity(in: self)
            // 方向
            if location.x - self.handlePanLastLocation!.x > 0 {
                self.calendarLogic.selectPreviousMonth()
            } else {
                self.calendarLogic.selectNextMonth()
            }
        }
    }
    
    private func contentSizeForViewInPopoverView() -> CGSize {
        return CGSize(width: self.calendarMonthFrame.size.width, height: self.calendarMonthFrame.size.height)
    }
    
    private func actionClearDate(sender: Any) {
        self.selectedDate = nil
        self.calendarMonth.selectButton(date: nil)
        self.calendarViewDelegate?.calendarView(aCalendarView: self, dateChanged: nil)
    }
    
    // MARK: Protocal Method(UIGestureRecognizerDelegate)
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location: CGPoint = gestureRecognizer.location(in: self)
        // 始终关注这个手势
        self.handlePanLastLocation = location
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return true
    }
    
    // MARK: Public Method
    
    /// 获取当前日历视图中的所有日期
    ///
    /// - Returns: 当前日历中的所有日期(NSDate类型，格林尼治标准时间)，按照顺序排列
    func getAllDatesInView() -> NSArray {
        return self.calendarMonth.datesIndex as NSArray
    }
    
    /// 在指定日期上添加一个标记
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - imageName: 用做标记的图片
    ///   - location: 相对位置
    func addMark(date: Date, imageName: String, location: PRCalendarMonthMarkLocation) {
        self.calendarMonth.addMark(date: date, imageName: imageName, location: location)
    }
    
    /// 删除指定日期上指定位置的标记
    ///
    /// - Parameters:
    ///   - date: 日期
    ///   - location: 相对位置
    func removeMark(date: Date, location: PRCalendarMonthMarkLocation) {
        self.calendarMonth.removeMark(date: date, location: location)
    }
    
    // MARK: delegate Method
    func calendarLogic(aLogic: PRCalendarLogic?, dateSelected: Date?) {
        _selectedDate = dateSelected
        // 如果日历逻辑的当前月 到本月的日期距离等于0
        if self.calendarLogic.distanceOfDateFromCurrentMonth(date: _selectedDate) == 0 {
            // 选择按钮设为selectedDate日期
            self.calendarMonth.selectButton(date: _selectedDate)
        }
        self.calendarViewDelegate?.calendarView(aCalendarView: self, dateChanged: dateSelected)
    }
    
    // 月份变化，aLogic－日历逻辑，aDirection－月份变化方向（正负）
    func calendarLogic(aLogic: PRCalendarLogic?, monthChangeDirection: NSInteger?) {
        let animate = true
        var distance = self.calendarMonthFrame.size.width
        if monthChangeDirection! < 0 {
            distance = -distance
        }
        
        self.leftBtn?.isUserInteractionEnabled = false
        self.rightBtn?.isUserInteractionEnabled = false
        let aCalendarMonth:PRCalendarMonth = PRCalendarMonth(frame: CGRect(x: distance, y: 0, width: self.calendarMonthFrame.size.width, height: self.calendarMonthFrame.size.height), logic: aLogic!)
        aCalendarMonth.isUserInteractionEnabled = false
        // 如果日历逻辑的当前月 到本月的日期距离等于0
        if self.calendarLogic.distanceOfDateFromCurrentMonth(date: self.selectedDate) == 0 {
            aCalendarMonth.selectButton(date: self.selectedDate)
        }
        // 插入视图aCalendarMonth到calendarMonth视图的上一层
        self.insertSubview(aCalendarMonth, belowSubview: self.calendarMonth)
        self.calendarMonthNew = aCalendarMonth
        // 如果当前视图已加载完成
        if animate {
            // 创建一个视图切换动画
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDelegate(self)
            // 结束后条用animationMonthSlideComplete
            UIView.setAnimationDidStop(#selector(animationMonthSlideComplete))
            //移动速度换算成动画时间
            var velocity:CGFloat = 0.8 - (fabs(self.panVelocity!.x)/10000 * 3)
            if velocity < 0.15 {
                velocity = 0.15
            }
            UIView.setAnimationDuration(TimeInterval(velocity))
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
        }
        
        // 设置月历视图的偏移
        self.calendarMonth.frame = self.calendarMonth.frame.offsetBy(dx: -distance, dy: 0)
        self.calendarMonthNew?.frame = (self.calendarMonthNew?.frame)!.offsetBy(dx: -distance, dy: 0);
        
        // 如果当前视图已加载完成
        if (animate) {
            // 提交动画
            UIView.commitAnimations()
        } else {
            // 没使用动画，则直接调用结束处理
            self.animationMonthSlideComplete()
        }
    }
    
    /// 月历滑动动画完成
    func animationMonthSlideComplete() {
        // Get rid of the old one.
        //移除月历视图（旧的）
        self.calendarMonth.removeFromSuperview()
        // replace
        // 刷新
        // 月历视图等于新月历视图
        self.calendarMonth = self.calendarMonthNew
        //新月历视图等于nil
        self.calendarMonthNew = nil
        
        //开始接受用户事件
        self.leftBtn?.isUserInteractionEnabled = true
        self.rightBtn?.isUserInteractionEnabled = true
        self.calendarMonth.isUserInteractionEnabled = true
        
        //通知代理滚动完成
        self.calendarViewScrollDelegate?.calendarViewDidScroll(aCalendarView: self, allDatesInView: self.calendarMonth.datesIndex as NSArray?)
        //展示的月份发生变化，aCalendarView－一个日历视图,aDate-变化的日期
        self.calendarViewDelegate?.calendarView(aCalendarView: self, mouthChanged: self.calendarLogic.referenceDate)
        self.isViewLoaded = true
    }
    
    
}
