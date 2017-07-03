//
//  PRSettingItem.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/3.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRSettingItem: NSObject {
    var uuid: String
    var title: String
    var switchState: Bool?
    
    init(dic: NSDictionary) {
        self.uuid = dic.object(forKey: "uuid") as! String
        self.title = dic.object(forKey: "title") as! String
        if dic.object(forKey: "defaultValue") != nil {
            self.switchState = dic.object(forKey: "defaultValue") as? Bool
        } else {
            self.switchState = false
        }
        
        let userNotFirstLogin = UserDefaults.standard.boolForUserStrKey(key: kPRUserNotFirstLogin)
        if userNotFirstLogin {
            self.switchState = UserDefaults.standard.boolForUserStrKey(key: self.uuid)
        } else {
            UserDefaults.standard.setBool(self.switchState!, forUserStrKey: self.uuid)
        }
        super.init()
    }
}
