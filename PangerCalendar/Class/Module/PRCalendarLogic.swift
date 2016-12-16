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
    var referenceDate: NSDate?
    
    //初始化，aDelegate－日历逻辑代理。aDate－基准日期
    init(delegate: PRCalendarLogicDelegate, referenceDate: NSDate) {
        super.init()
        calendarLogicDelegate = delegate;
        //创建一个创建一个日期组件，并赋予要设置的日期
        
//        var componets = NSCalendar(calendari)
//        NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:aDate];
//        //返回日期（统一格式）
//        referenceDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    }
    
    func dateForToday() -> NSDate {
        return nil
    }
}
