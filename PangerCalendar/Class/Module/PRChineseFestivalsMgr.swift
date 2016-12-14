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
    
    private func festivalIndex(month: Int, day: Int) -> Int {
        return month * 100 + day
    }
    
    func festival(month: Int, day: Int) -> String {
        var festivalStr: String = ""
        switch self.festivalIndex(month: month, day: day) {
        case self.festivalIndex(month: 1, day: 1): festivalStr = "元旦"; break
        case self.festivalIndex(month: 2, day: 14): festivalStr = "情人节"; break
        case self.festivalIndex(month: 4, day: 1): festivalStr = "愚人节"; break
        case self.festivalIndex(month: 5, day: 1): festivalStr = "劳动节"; break
        case self.festivalIndex(month: 5, day: 4): festivalStr = "青年节"; break
        case self.festivalIndex(month: 6, day: 1): festivalStr = "儿童节"; break
        case self.festivalIndex(month: 8, day: 1): festivalStr = "建军节"; break
        case self.festivalIndex(month: 9, day: 10): festivalStr = "教师节"; break
        case self.festivalIndex(month: 10, day: 1): festivalStr = "国庆"; break
        case self.festivalIndex(month: 12, day: 24): festivalStr = "平安夜"; break
        case self.festivalIndex(month: 12, day: 25): festivalStr = "圣诞节"; break
        default: festivalStr = ""; break
        }
        return festivalStr
    }

    func lunarFestival(month: Int, day: Int) -> String {
        var festivalStr: String = ""
        switch self.festivalIndex(month: month, day: day) {
        case self.festivalIndex(month: 1, day: 1): festivalStr = "春节"; break
        case self.festivalIndex(month: 1, day: 15): festivalStr = "元宵"; break
        case self.festivalIndex(month: 5, day: 5): festivalStr = "端午"; break
        case self.festivalIndex(month: 7, day: 7): festivalStr = "七夕"; break
        case self.festivalIndex(month: 7, day: 15): festivalStr = "中元"; break
        case self.festivalIndex(month: 8, day: 15): festivalStr = "中秋"; break
        case self.festivalIndex(month: 9, day: 9): festivalStr = "重阳"; break
        case self.festivalIndex(month: 12, day: 8): festivalStr = "腊八"; break
        case self.festivalIndex(month: 12, day: 23): festivalStr = "小年"; break
        case self.festivalIndex(month: 12, day: 30): festivalStr = "除夕"; break
        default: festivalStr = ""
        }
        return festivalStr
    }
    
}
