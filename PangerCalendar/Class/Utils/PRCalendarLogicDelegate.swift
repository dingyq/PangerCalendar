//
//  PRCalendarLogicDelegate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/12/15.
//  Copyright © 2016年 panger. All rights reserved.
//

import Foundation
// 日历逻辑代理，将日期选择，月份变化（翻页）等实现交由代理完成
protocol PRCalendarLogicDelegate {
    // 日期被选择，aLogic－日历逻辑，aDate－选择的日期
    func calendarLogic(aLogic: PRCalendarLogic?, dateSelected: Date?)
    
    // 月份变化，aLogic－日历逻辑，aDirection－月份变化方向（正负）
    func calendarLogic(aLogic: PRCalendarLogic?, monthChangeDirection: NSInteger?)
}
