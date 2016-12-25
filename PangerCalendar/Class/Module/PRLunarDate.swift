//
//  PRLunarDate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/13.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

enum PRDatePriorityLabelType: Int {
    case null = -1
    case day  =  0
    case solarterm
    case lunarFestival
    case festival
}


class PRLunarDate: NSObject {
    //日
    public private(set) var iday: Int?
    //月
    public private(set) var imonth: Int?
    //年
    public private(set) var iyear: Int?
    
    //日
    public private(set) var day: String = ""
    //月
    public private(set) var month: String = ""
    //黄道(属)
    public private(set) var zodiac: String = ""

    //天干
    public private(set) var tiangan: String = ""
    //地支
    public private(set) var dizhi: String = ""

    //节气
    public private(set) var solarterm: String = ""
    
    //（阳历）节日
    public private(set) var festival: String = ""
    //阴历节日
    public private(set) var lunarFestival: String = ""

    //优先标签
    public private(set) var priorityLabel: String = ""
    
    //优先标签类型
    public private(set) var priorityLabelType: PRDatePriorityLabelType = PRDatePriorityLabelType.null
    
    //初始化一个农历日期，使用公历的年月日
    class func lunarDateWithYear(year: Int, month: Int, day: Int) -> PRLunarDate {
        return PRLunarDate.init(year: year, month: month, day: day)
    }
    
    //初始化一个农历日期，使用公历日期
    class func lunarDateWithNSDate(date: Date) -> PRLunarDate {
        //创建一个当前用户的日历对象（NSCalendar用于处理时间相关问题。比如比较时间前后、计算日期所的周别等。）
        let calendar = Calendar.current
        //创建一个日期组件，并赋予当前日期
        let components = calendar .dateComponents([Calendar.Component.day, Calendar.Component.month, Calendar.Component.year], from: date)
        return PRLunarDate.lunarDateWithYear(year: components.year!, month: components.month!, day: components.day!)
    }
    
    public init(year: Int, month: Int, day: Int) {
        super.init()
        let lunarDateAlMgr = PRLunarDateAlgorithm.shareMgr()
        let lunarDate = lunarDateAlMgr.lunardateFromSolar(year: year, month: month, day: day)
        //年月日
        self.iday = lunarDate.day;
        self.imonth = lunarDate.month;
        self.iyear = lunarDate.year;

        //日 月 年（属）
        var resultStr = lunarDateAlMgr.lunarDateDay(lunarDay: lunarDate.day)
        if !resultStr.isEmpty {
            self.day = resultStr
        } else {
            self.day = ""
        }
        resultStr = lunarDateAlMgr.lunarDateMonth(lunarMonth: lunarDate.month)
        if !resultStr.isEmpty {
            self.month = resultStr
        } else {
            self.month = ""
        }
        resultStr = lunarDateAlMgr.lunarDateZodiac(lunarYear: lunarDate.year)
        if !resultStr.isEmpty {
            self.zodiac = resultStr
        } else {
            self.zodiac = ""
        }
        
        //天干 地支
        self.tiangan = lunarDateAlMgr.lunarDateTianGan(lunarYear: lunarDate.year)
        self.dizhi = lunarDateAlMgr.lunarDateDiZhi(lunarYear: lunarDate.year)
        
        //节气
        let solarTermMgr = PRSolarTermsMgr.shareMgr()
        self.solarterm = solarTermMgr.solartermName(index: solarTermMgr.solartermIndex(year: year, month: month, day: day))
        
        //阳历节日 阴历节日
        let cFestivalsMgr = PRChineseFestivalsMgr.shareMgr()
        self.festival = cFestivalsMgr.festival(month: month, day: day)
        self.lunarFestival = cFestivalsMgr.lunarFestival(month: lunarDate.month, day: lunarDate.day)
        
        //优先的农历标签
        self.priorityLabel = self.priorityLunarLabel()
    }
    
    private func priorityLunarLabel() -> String {
        if (!self.festival.isEmpty) {
            //阳历节日
            self.priorityLabelType = PRDatePriorityLabelType.festival
            return self.festival
        } else if (!self.lunarFestival.isEmpty) {
            //阴历节日
            self.priorityLabelType = PRDatePriorityLabelType.lunarFestival
            return self.lunarFestival
        } else if (!self.solarterm.isEmpty) {
            //节气
            self.priorityLabelType = PRDatePriorityLabelType.solarterm
            return self.solarterm;
        } else if (!self.day.isEmpty) {
            self.priorityLabelType = PRDatePriorityLabelType.day
            return self.day;
        } else {
            self.priorityLabelType = PRDatePriorityLabelType.null
            return ""
        }
    }
}
