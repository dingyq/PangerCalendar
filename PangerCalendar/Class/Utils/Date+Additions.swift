//
//  Date+Additions.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//


/*
 G -- 纪元              一般会显示公元前(BC)和公元(AD)
 y -- 年                假如是2013年，那么 yyyy=2013，yy=13
 M -- 月                假如是3月，那么 M=3，MM=03，MMM=Mar，MMMM=March；
 假如是11月，那么M=11，MM=11，MMM=Nov，MMMM=November
 w -- 一年中的第几周     假如是1月8日，那么 w=2(这一年的第二个周)
 W -- 一个月中的第几周   与日历排列有关，假如是2013年4月21日，那么 W=4(这个月的第四个周)
 F -- 月份包含的周       与日历排列无关，和上面的 W 不一样，F 只是单纯以7天为一个单位来统计周，
 例如7号一定是第一个周，15号一定是第三个周，与日历排列无关。
 D -- 一年中的第几天     假如是1月20日，那么 D=20(这一年的第20天)；假如是2月25日，那么 D=31+25=56(这一年的第56天)
 d -- 一个月中的第几天   假如是5号，那么 d=5，dd=05   假如是15号，那么 d=15，dd=15
 E -- 星期几            假如是星期五，那么 E=Fri，EEEE=Friday
 a -- 上午(AM)/下午(PM)
 H -- 24小时制          显示为0--23，假如是午夜00:40，那么 H=0:40，HH=00:40
 h -- 12小时制          显示为1--12，假如是午夜00:40，那么 h=12:40
 K -- 12小时制          显示为0--11，假如是午夜00:40，那么 K=0:40，KK=00:40
 k -- 24小时制          显示为1--24，假如是午夜00:40，那么 k=24:40
 m -- 分钟              假如是5分钟，那么 m=5，mm=05；假如是45分钟，那么 m=45，mm=45
 s -- 秒                假如是5秒钟，那么 s=5，ss=05；假如是45秒钟，那么 s=45，ss=45
 S -- 毫秒              一般用 SSS 来显示
 z -- 时区              表现形式为 GMT+08:00
 Z -- 时区              表现形式为 +0800
 */

import Foundation

extension Date {
    static func appMin() -> Date {
        return Calendar.current.date(from: DateComponents.appMin())!
    }
    
    static func appMax() -> Date {
        return Calendar.current.date(from: DateComponents.appMax())!
    }
    
    func defaultMissionTime() -> Date {
        let selfCom = Calendar.current.dateComponents([.year, .month, .day], from: self)
        var tempCom = DateComponents()
        tempCom.timeZone = kPRTimeZone
        tempCom.year = selfCom.year
        tempCom.month = selfCom.month
        tempCom.day = selfCom.day
        let curCom = Calendar.current.dateComponents([.hour, .minute], from: Date())
        tempCom.hour = (curCom.hour! + 1) % 24
        tempCom.minute = 0
        return Calendar.current.date(from: tempCom)!
    }
    
    static func currentTime() -> Date {
        let selfCom = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        var tempCom = DateComponents()
        tempCom.timeZone = kPRTimeZone
        tempCom.year = selfCom.year
        tempCom.month = selfCom.month
        tempCom.day = selfCom.day
        tempCom.hour = selfCom.hour
        tempCom.minute = selfCom.minute
        return Calendar.current.date(from: tempCom)!
    }
    
    func midnight() -> Date {
        return self.assign(hour: 23, minute: 59)
    }
    
    func assign(hour: Int, minute: Int) -> Date {
        let selfCom = Calendar.current.dateComponents([.year, .month, .day], from: self)
        var tempCom = DateComponents()
        tempCom.timeZone = kPRTimeZone
        tempCom.year = selfCom.year
        tempCom.month = selfCom.month
        tempCom.day = selfCom.day
        tempCom.hour = hour
        tempCom.minute = minute
        return Calendar.current.date(from: tempCom)!
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
        dateFmt.timeZone = kPRTimeZone
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
        let result1 = PRHuangliDB.manager.queryDataWithDateInt(year: components.year!, month: components.month!, day: components.day!)
        if result1.count > 0 {
            let dic: Dictionary = result1.first!
            return String.init(format:"%@", dic["fit"]!)
        }
        return ""
    }
    
    func jiZuoStr() -> String {
        let components = Calendar.current.dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: self)
        let result1 = PRHuangliDB.manager.queryDataWithDateInt(year: components.year!, month: components.month!, day: components.day!)
        if result1.count > 0 {
            let dic: Dictionary = result1.first!
            return String.init(format:"%@", dic["avoid"]!)
        }
        return ""
    }
    
    func mDDHHStr() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = kPRTimeZone
        formatter.dateFormat = "MM/dd hh:mm"
        let strDate = formatter.string(from: self)
        return strDate
    }
    
    func yyyyMDDhhmmStr() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = kPRTimeZone
        formatter.dateFormat = "yyyy年M月d日 HH:mm"
        let strDate = formatter.string(from: self)
        return strDate
    }
    
    func yyyyMDDStr() -> String {
        let formatter = DateFormatter()
        formatter.timeZone = kPRTimeZone
        formatter.dateFormat = "yyyy年M月d日"
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
