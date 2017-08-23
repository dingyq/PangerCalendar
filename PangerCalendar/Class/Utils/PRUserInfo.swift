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
    private var missionDataChanged: Bool = true
    private var missionClassifiedListArr:Array<Array<PRMissionNoticeModel>>
    var relationList:Array<PRUserModel>
    
    override init() {
        self.profile = PRUserModel(userId: 1000, name: "yongqiang")
        self.missionList = []
        self.missionClassifiedListArr = []
        self.relationList = [self.profile]
        super.init()
        
//        let result = PRMissionsDataMgr.moreData(sortId: 0)
//        for dic in result {
//            self.missionList.append(PRMissionNoticeModel(dic))
//        }
        
        
    }
    
    func add(member: PRUserModel) -> Bool {
        self.relationList.append(member)
        return true
    }
    
    func updateProfile() {
        self.profile.userName = "dickding"
    }
    
    func isMissionDataEdited() -> Bool {
        return self.missionDataChanged
    }
    
    func querryAll(resultBlock: @escaping(_ requestStatues: Bool, Error?) -> ()) {
        PRMissionServiceMgr.querryAll(userId: self.profile.userId, success: { (result) in
            self.missionList = result
            self.missionDataChanged = true
            resultBlock(true, nil)
        }) { (error) in
            resultBlock(false, nil)
        }
    }
    
    func add(mission: PRMissionNoticeModel) -> Bool {
        PRMissionServiceMgr.add(mission: mission, success: { (missionR) in
            if mission.needClock == .push {
                self.missionList.append(mission)
                self.missionDataChanged = true
                PRNotificationReminder.default.add(mission: missionR)
            }
        }, fail: { (error) in
            
        })
        return true
    }
    
    func remove(mission: PRMissionNoticeModel) -> Bool {
        PRMissionServiceMgr.remove(mission: mission, success: { (missionR) in
            for (index, item) in self.missionList.enumerated() {
                if item == mission {
                    self.missionList.remove(at: index)
                }
            }
            self.missionDataChanged = true
            let _ = PRNotificationReminder.default.remove(mission: mission)
        }, fail: { (error) in
            
        })
        return true;
    }
    
    func update(_ mission: PRMissionNoticeModel?) {
        if mission != nil {
            PRMissionServiceMgr.update(mission: mission!, success: { (mission) in
                self.missionDataChanged = true
                if mission.state != .done {
                    PRNotificationReminder.default.add(mission: mission)
                } else {
                    let _ = PRNotificationReminder.default.remove(mission: mission)
                }
            }) { (error) in
                
            }
        }
    }
    
    func missionClassifiedList() -> Array<Array<PRMissionNoticeModel>> {
        if self.missionDataChanged {
            self.missionDataChanged = false
            self.missionClassifiedListArr.removeAll()
            
            var newArr = Array<PRMissionNoticeModel>()
            var timeOutArr = Array<PRMissionNoticeModel>()
            var doingArr = Array<PRMissionNoticeModel>()
            var doneArr = Array<PRMissionNoticeModel>()
            for item in self.missionList {
                switch item.state {
                case .new:
                    if (item.deadlineTime != 0 && item.deadlineTime < Double(Date().timeIntervalSince1970)) {
                        timeOutArr.append(item)
                    } else {
                        newArr.append(item)
                    }
                case .doing:
                    doingArr.append(item)
                case .done:
                    doneArr.append(item)
                }
            }
            self.missionClassifiedListArr.append(doingArr)
            self.missionClassifiedListArr.append(timeOutArr)
            self.missionClassifiedListArr.append(newArr)
            self.missionClassifiedListArr.append(doneArr)
        }
        return self.missionClassifiedListArr
    }
}

