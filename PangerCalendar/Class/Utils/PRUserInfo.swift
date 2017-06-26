//
//  PRUserInfo.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private let s_Instance:PRUserInfo = PRUserInfo()
let PRUserData:PRUserInfo = s_Instance

class PRUserInfo: NSObject {
    var missonList:Array<PRMissionNoticeModel>
    
    override init() {
        self.missonList = []
        super.init()
    }
    
    func add(missonNotice: PRMissionNoticeModel) -> Bool {
        self.missonList.append(missonNotice)
        
        return true
    }
}

