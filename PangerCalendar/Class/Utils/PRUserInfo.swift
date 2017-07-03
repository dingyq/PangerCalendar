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
    var profile:PRUserModel
    var missionList:Array<PRMissionNoticeModel>
    var relationList:Array<PRUserModel>
    
    override init() {
        self.profile = PRUserModel(userId: 1000, name: "yongqiang")
        self.missionList = []
        let result = PRMissionsDataMgr.getLatestData(0)
        for dic in result {
            let model = PRMissionNoticeModel(dic)
            self.missionList.append(model)
        }
        self.relationList = [self.profile]
        super.init()
    }
    
    func add(mission: PRMissionNoticeModel) -> Bool {
        self.missionList.append(mission)
        return true
    }
    
    func add(member: PRUserModel) -> Bool {
        self.relationList.append(member)
        return true
    }
    
    func updateProfile() {
        self.profile.userName = "dickding"
    }
    
}

