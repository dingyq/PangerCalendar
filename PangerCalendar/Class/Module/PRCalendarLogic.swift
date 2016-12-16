//
//  PRCalendarLogic.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/15.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

class PRCalendarLogic: NSObject {
 
    var calendarLogicDelegate: PRCalendarLogicDelegate?
    var referenceDate: Date?
    
    // 初始化，aDelegate－日历逻辑代理。aDate－基准日期
    init(delegate: PRCalendarLogicDelegate, aDate: Date) {
        super.init()
        calendarLogicDelegate = delegate;
        //创建一个创建一个日期组件，并赋予要设置的日期
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month], from: aDate)
        //返回日期（统一格式）
        referenceDate = Calendar.current.date(from: components)
    }
    
    // 返回当前日期
    func dateForToday() -> Date {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
        // 返回日期（统一格式）
        return Calendar.current.date(from: components)!
    }
    
    // 构造一个日期。aWeekday－星期几，aWeek－第几周（今年），aReferenceDate－日期（只含月和年）
    func date(weekday: Int, week: Int, referenceDate: Date) -> Date {
        // 使用参数aReferenceDate构造日期组件
        let components = Calendar.current.dateComponents([Calendar.Component.month, Calendar.Component.year], from: referenceDate)
        let month = components.month!
        let year = components.year!
        return self.date(weekday: weekday, week: week, month: month, year: year)
    }
    
    // 构造一个日期。weekday－星期几，week－第几周（今年），month－月，year－年
    func date(weekday: Int, week: Int, month: Int, year: Int) -> Date {
        let calendar = Calendar.current
        // Select first 'firstWeekDay' in this month
        // 构造一个NSDateComponents
        var firstStartDayComponents = DateComponents()
        firstStartDayComponents.month = month
        firstStartDayComponents.year = year
        firstStartDayComponents.weekday = weekday
        firstStartDayComponents.weekdayOrdinal = 1  // 这个月的第几周
        let firstDayDate = calendar.date(from: firstStartDayComponents)
        
        // Grab just the day part.
        firstStartDayComponents = calendar.dateComponents([Calendar.Component.day], from: firstDayDate!)
        
        let maxRange = calendar.maximumRange(of: Calendar.Component.weekday)
        let numberOfDaysInWeek = maxRange!.upperBound - maxRange!.lowerBound
        
        var firstDay: Int = firstStartDayComponents.day! - numberOfDaysInWeek
        // Correct for day landing on the firstWeekday
        if firstDay - 1 == -numberOfDaysInWeek {
            firstDay = 1
        }
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = week * numberOfDaysInWeek + firstDay + weekday - 1
        return calendar.date(from: components)!
    }
    
}
