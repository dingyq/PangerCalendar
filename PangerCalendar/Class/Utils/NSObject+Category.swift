//
//  NSObject+Category.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/2.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

extension NSObject {
    
    class func fromClassName(className : String) -> NSObject {
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + className
        let aClass = NSClassFromString(className) as! UIViewController.Type
        return aClass.init()
    }
    
}
