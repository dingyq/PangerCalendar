//
//  DateComponents+Additions.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/7/9.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

extension DateComponents {
    static func appMin() -> DateComponents {
        var components = DateComponents()
        components.timeZone = kPRTimeZone
        components.year = 1901
        components.month = 1
        components.day = 1
        components.hour = 0
        components.minute = 0
        return components
    }
    
    static func appMax() -> DateComponents {
        var components = DateComponents()
        components.timeZone = kPRTimeZone
        components.year = 2100
        components.month = 12
        components.day = 31
        components.hour = 23
        components.minute = 59
        return components
    }
    
    static func today() -> DateComponents {
        let calendar = Calendar.current
        var comps = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: Date())
        comps.timeZone = kPRTimeZone
        return comps
    }
}
