//
//  PRChineseFestivalsMgr.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/12.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation

//enum PRChineseFestival: Int {
//    case NONE = 0
//    case NewYearDay = 101               // 元旦
//    case ValentineDay = 214             // 情人节
//    case AprilFoolsDay = 401            // 愚人节
//    case LabourDay = 501                // 劳动节
//    case YouthDay = 504                 // 青年节
//    case ChildrenDay = 601              // 儿童节
//    case ArmyDay = 801                  // 建军节
//    case TeachersDay = 910              // 教师节
//    case NationalDay = 1001             // 国庆
//    case ChristmasEve = 1224            // 平安夜
//    case ChristmasDay = 1225            // 圣诞节
//}

private let s_Instance: PRChineseFestivalsMgr = PRChineseFestivalsMgr()

class PRChineseFestivalsMgr: NSObject {
    
    class func shareMgr() -> PRChineseFestivalsMgr {
        return s_Instance
    }
    
    private func holidayIndex(_ year: Int, _ month: Int, _ day: Int) -> Int {
        return month * 100 + day
    }
    
    private func festivalIndex(_ month: Int, _ day: Int) -> Int {
        return month * 100 + day
    }
    
    func soloarFestival(month: Int, day: Int) -> String {
        var festivalStr: String = ""
        switch festivalIndex(month, day) {
        case festivalIndex(1, 1): festivalStr = "元旦"
        case festivalIndex(2, 14): festivalStr = "情人节"
        case festivalIndex(4, 1): festivalStr = "愚人节"
        case festivalIndex(5, 1): festivalStr = "劳动节"
        case festivalIndex(5, 4): festivalStr = "青年节"
        case festivalIndex(6, 1): festivalStr = "儿童节"
        case festivalIndex(8, 1): festivalStr = "建军节"
        case festivalIndex(9, 10): festivalStr = "教师节"
        case festivalIndex(10, 1): festivalStr = "国庆"
        case festivalIndex(12, 24): festivalStr = "平安夜"
        case festivalIndex(12, 25): festivalStr = "圣诞节"
        default: festivalStr = ""
        }
        return festivalStr
    }

    func lunarFestival(month: Int, day: Int) -> String {
        var festivalStr: String = ""
        switch festivalIndex(month, day) {
        case festivalIndex(1, 1): festivalStr = "春节"
        case festivalIndex(1, 15): festivalStr = "元宵"
        case festivalIndex(5, 5): festivalStr = "端午"
        case festivalIndex(7, 7): festivalStr = "七夕"
        case festivalIndex(7, 15): festivalStr = "中元"
        case festivalIndex(8, 15): festivalStr = "中秋"
        case festivalIndex(9, 9): festivalStr = "重阳"
        case festivalIndex(12, 8): festivalStr = "腊八"
        case festivalIndex(12, 23): festivalStr = "小年"
        case festivalIndex(12, 30): festivalStr = "除夕"
        default: festivalStr = ""
        }
        return festivalStr
    }
    
    private func isSolarHoliday(_ year: Int, _ month: Int, _ day: Int) -> Bool {
        var result = false
        switch holidayIndex(year, month, day) {
        case holidayIndex(year, 1, 1)...holidayIndex(year, 1, 3): result = true
        case holidayIndex(year, 5, 1)...holidayIndex(year, 5, 3): result = true
        case holidayIndex(year, 10, 1)...holidayIndex(year, 10, 7): result = true
        default: result = false
        }
        
        let date = self.qingmingDate(year: year)
        if date != nil {
            let calendar = Calendar.current
            let comp = calendar.dateComponents([.day, .month, .year], from: date!)
            if comp.year == year {
                let index = holidayIndex(year, month, day)
                if (index >= holidayIndex(year, comp.month!, comp.day!) && index <= holidayIndex(year, comp.month!, comp.day!+2)) {
                    result = true
                }
            }
        }
        return result
    }
    
    private func isLunarHoliday(_ year: Int, _ month: Int, _ day: Int) -> Bool {
        var result = false
        switch holidayIndex(year, month, day) {
        case holidayIndex(year, 1, 1)...holidayIndex(year, 1, 6): result = true
        case holidayIndex(year, 5, 5)...holidayIndex(year, 5, 7): result = true
        case holidayIndex(year, 8, 15)...holidayIndex(year, 8, 17): result = true
        case holidayIndex(year, 12, 30): result = true
        default: result = false
        }
        return result
    }
    
    private func qingmingDate(year: Int) -> Date? {
        for i in 1...15 {
            if PRSolarTermsMgr.shareMgr().solartermIndex(year: year, month: 4, day: i) == 4 {
                var comp = DateComponents()
                comp.year = year
                comp.month = 4
                comp.day = i
                return Calendar.current.date(from: comp)
            }
        }
        return nil
    }
    
    func isHoliday(year: Int, month: Int, day: Int) -> Bool {
        let lunarDateAlMgr = PRLunarDateAlgorithm.shareMgr()
        let lunarDate = lunarDateAlMgr.lunardateFromSolar(year: year, month: month, day: day)
        return self.isSolarHoliday(year, month, day) || self.isLunarHoliday(lunarDate.year, lunarDate.month, lunarDate.day)
    }
    
}
