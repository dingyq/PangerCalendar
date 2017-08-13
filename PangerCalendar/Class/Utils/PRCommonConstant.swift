//
//  PRCommonConstant.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

//let kPRTimeZone = "GMT + 8"

//let kPRServerHost = "http://995078.com:3000"
let kPRServerHost = "http://localhost:3000"

let kPRAppMinDate = Date.appMin()
let kPRAppMaxDate = Date.appMax()

var kPRScreenWidth:CGFloat {
    return UIScreen.main.bounds.width
}

var kPRScreenHeight:CGFloat {
    return UIScreen.main.bounds.height
}

let kPRTimeZone = NSTimeZone.system

let kPathOfDocument: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
let kPRCalenderViewFrameChangedNotify = NSNotification.Name(rawValue: "kPRCalenderViewFrameChangedNotify")
let kPRUserNotFirstLogin: String = "kPRUserNotFirstLogin"
