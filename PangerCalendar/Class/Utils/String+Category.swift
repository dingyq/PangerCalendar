//
//  String+Category.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/28.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

extension String {
    
    var lastPathComponent: String {
        return (self as NSString).lastPathComponent
    }
    
    var pathExtension: String {
        return (self as NSString).pathExtension
    }
    
    var deletingLastPathComponent: String {
        return (self as NSString).deletingLastPathComponent
    }
    
    var deletingPathExtension: String {
        return (self as NSString).deletingPathExtension
    }
    
    var pathComponents: [String] {
        return (self as NSString).pathComponents
    }
    
    func appendingPathComponent(path: String) -> String {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    func appendingPathExtension(ext: String) -> String? {
        let nsSt = self as NSString
        return nsSt.appendingPathExtension(ext)
    }
}
