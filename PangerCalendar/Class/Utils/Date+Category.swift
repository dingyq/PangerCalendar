//
//  Date+Category.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

extension Date {
    
    static func appMinDate() -> Date {
        var components = DateComponents()
        components.timeZone = TimeZone(abbreviation: "GMT")
        components.year = 1901
        components.month = 1
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    static func appMaxDate() -> Date {
        var components = DateComponents()
        components.timeZone = TimeZone(abbreviation: "GMT")
        components.year = 2100
        components.month = 12
        components.day = 31
        return Calendar.current.date(from: components)!
    }
    
    func weekOfYearStr() -> String {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([Calendar.Component.weekOfYear], from: self)
        return String.init(format: "第%i周", comps.weekOfYear!)
        //            [calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
        //        let components = calendar.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: Date())
    }
    
    func weekDayStr() -> String {
        let calendar = Calendar.current
        let comps = calendar.dateComponents([Calendar.Component.weekday], from: self)
        let dateFmt = DateFormatter()
        let daySymbols = dateFmt.shortWeekdaySymbols!
        let weekday = (abs(comps.weekday! - 1))%7
        return daySymbols[weekday]
    }
    
    func dayStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day], from: self)
        return String.init(format:"%i", components.day!)
    }
    
    func lunarDateStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        let lunarMgr = PRLunarDateAlgorithm.shareMgr()
        let lunar = lunarMgr.lunardateFromSolar(year: components.year!, month: components.month!, day: components.day!)
        return String.init(format:"%@%@", lunarMgr.lunarDateMonth(lunarMonth: lunar.month), lunarMgr.lunarDateDay(lunarDay: lunar.day))
    }
    
    func ganZhiZodiacStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        let lunarMgr = PRLunarDateAlgorithm.shareMgr()
        let lunar = lunarMgr.lunardateFromSolar(year: components.year!, month: components.month!, day: components.day!)
        return String.init(format: "%@%@年【%@】",
                    lunarMgr.lunarDateTianGan(lunarYear: lunar.year),
                    lunarMgr.lunarDateDiZhi(lunarYear: lunar.year),
                    lunarMgr.lunarDateZodiac(lunarYear: lunar.year))
    }
    
    func yiZuoStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        let result1 = PRHuangliData.manager.queryDataWithDateInt(year: components.year!, month: components.month!, day: components.day!)
        if result1.count > 0 {
            let dic: Dictionary = result1.first!
            return String.init(format:"%@", dic["fit"]!)
        }
        return ""
    }
    
    func jiZuoStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        let result1 = PRHuangliData.manager.queryDataWithDateInt(year: components.year!, month: components.month!, day: components.day!)
        if result1.count > 0 {
            let dic: Dictionary = result1.first!
            return String.init(format:"%@", dic["avoid"]!)
        }
        return ""
    }
    
    func mDDStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M/dd"
        let strDate = formatter.string(from: self)
        return strDate
    }
    
    func yyyyMDDStr() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月dd日"
        let strDate = formatter.string(from: self)
        return strDate
    }
    
//    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
//    
//    
//    fromDate:date];
//    
//    
//    NSInteger week = [comps week]; // 今年的第几周
//    
//    
//    NSIntegerweekday = [comps weekday]; // 星期几（注意，周日是“1”，周一是“2”。。。。）
//    
//    
//    NSIntegerweekdayOrdinal = [comps weekdayOrdinal]; // 这个月的第几周

}
