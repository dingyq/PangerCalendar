//
//  UserDefaults+Additions.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/3.
//  Copyright © 2017年 panger. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    func boolForUserStrKey(key: String) -> Bool {
        let userKey = "\(PRUserData.profile.userId)_\(key)"
        return self.bool(forKey: userKey)
    }
    
    func setBool(_ value: Bool, forUserStrKey: String) {
        let userKey = "\(PRUserData.profile.userId)_\(forUserStrKey)"
        self.set(value, forKey: userKey)
    }
}
