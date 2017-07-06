//
//  PRCommonConstant.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

//let kPRTimeZone = "GMT + 8"

let kPRTimeZone = NSTimeZone.system

let kPathOfDocument: String = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).first!
let kPRCalenderViewFrameChangedNotify = NSNotification.Name(rawValue: "kPRCalenderViewFrameChangedNotify")
let kPRUserNotFirstLogin: String = "kPRUserNotFirstLogin"
