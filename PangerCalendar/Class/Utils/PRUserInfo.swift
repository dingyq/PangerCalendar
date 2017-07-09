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
        
        let result = PRMissionsDataMgr.moreData(sortId: 0)
        for dic in result {
            self.missionList.append(PRMissionNoticeModel(dic))
        }
        self.missionDataChanged = true
    }
    
    func add(mission: PRMissionNoticeModel) -> Bool {
        self.missionList.append(mission)
        self.missionDataChanged = true
        if mission.needClock == .push {
            PRNotificationReminder.default.add(mission: mission)
        }
        PRMissionsDataMgr.syncData(dataArr: [mission.serializeToDictionary()])
        return true
    }
    
    func remove(mission: PRMissionNoticeModel) -> Bool {
        for (index, item) in self.missionList.enumerated() {
            if item == mission {
                self.missionList.remove(at: index)
                self.missionDataChanged = true
                let _ = PRNotificationReminder.default.remove(mission: mission)
                PRMissionsDataMgr.deleteData(dataArr: [mission.serializeToDictionary()])
                return true
            }
        }
        return false
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
    
    func markMissionEdited(_ mission: PRMissionNoticeModel?) {
        if mission != nil {
            self.missionDataChanged = true
            if mission!.state != .done {
                PRNotificationReminder.default.add(mission: mission!)
            } else {
                let _ = PRNotificationReminder.default.remove(mission: mission!)
            }
            PRMissionsDataMgr.syncData(dataArr: [mission!.serializeToDictionary()])
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
    
//    private func getMissonList(state: PRMissionState) -> Array<PRMissionNoticeModel> {
//        var tmpArr = Array<PRMissionNoticeModel>()
//        for item in self.missionList {
//            if item.state == state {
//                tmpArr.append(item)
//            }
//        }
//        return tmpArr
//    }
}

