//
//  PRCalendarViewScrollDelegate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/11.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

protocol PRCalendarViewScrollDelegate {
    
    /// 日历换页结束
    ///
    /// - Parameters:
    ///   - aCalendarView: 一个日历视图
    ///   - allDatesInView: 当前视图中的所有日期
    func calendarViewDidScroll(aCalendarView: PRCalendarView?, allDatesInView: NSArray?)
}
