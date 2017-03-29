//
//  PRCalendarViewDelegate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/11.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

protocol PRCalendarViewDelegate {
    
    /// 选择的日期发生变化
    ///
    /// - Parameters:
    ///   - aCalendarView: 一个日历视图
    ///   - dateChanged: 变化的日期
    func calendarView(aCalendarView: PRCalendarView?, dateChanged: Date?)
    
    /// 展示的月份发生变化
    ///
    /// - Parameters:
    ///   - aCalendarView: 一个日历视图
    ///   - mouthChanged: 变化的日期
    func calendarView(aCalendarView: PRCalendarView?, monthChanged: Date?)
    
}
