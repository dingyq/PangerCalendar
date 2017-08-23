//
//  PRMissionManager.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/8/23.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

let PRMissionServiceMgr = PRMissionService()

class PRMissionService: NSObject {
    override init() {
        super.init()
    }
    
    func add(mission: PRMissionNoticeModel, success: @escaping(PRMissionNoticeModel) -> (), fail: @escaping(Error?) -> ()) {
        let requestUrl = kPRServerHost+"/mission/add"
        let tmpDic = NSMutableDictionary()
        tmpDic.setValue(NSNumber(value: mission.state.rawValue), forKey: "state")
        tmpDic.setValue(NSNumber(value: mission.deadlineTime), forKey: "deadlineTime")
        tmpDic.setValue(mission.createUserName, forKey: "createUserName")
        tmpDic.setValue(NSNumber(value: mission.completeTime), forKey: "completeTime")
        tmpDic.setValue(NSNumber(value: mission.type.rawValue), forKey: "type")
        tmpDic.setValue(mission.title, forKey: "title")
        tmpDic.setValue(NSNumber(value: mission.createTime), forKey: "createTime")
        if mission.dutyPerson != nil {
            tmpDic.setValue(NSNumber(value: (mission.dutyPerson?.userId)!), forKey: "dutyId")
            tmpDic.setValue(mission.dutyPerson?.userName, forKey: "dutyName")
        } else {
            tmpDic.setValue(PRUserData.profile.userId, forKey: "dutyId")
            tmpDic.setValue(mission.dutyPerson?.userName, forKey: "dutyName")
        }
        tmpDic.setValue(NSNumber(value: mission.createUserId), forKey: "createUserId")
        tmpDic.setValue(NSNumber(value: mission.needClock.rawValue), forKey: "needClock")
        tmpDic.setValue(mission.content, forKey: "content")
        
        PRNetworkTool.shareInstance.request(requestType: .Get, url: requestUrl, parameters: tmpDic as? [String : Any]) { (response, error) in
            if (error == nil && response != nil) {
//                PRMissionsDataMgr.syncData(dataArr: [mission.serializeToDictionary()])
                success(mission)
            } else {
                fail(error)
            }
        }
    }
    
    func remove(mission: PRMissionNoticeModel, success: @escaping(PRMissionNoticeModel) -> (), fail: @escaping(Error?) -> ()) {
        let requestUrl = kPRServerHost+"/mission/delete"
        let tmpDic = NSMutableDictionary()
        tmpDic.setValue(NSNumber(value: mission.missionId), forKey: "missionId")
        PRNetworkTool.shareInstance.request(requestType: .Get, url: requestUrl, parameters: tmpDic as? [String : Any]) { (response, error) in
            if (error == nil && response != nil) {
//                PRMissionsDataMgr.deleteData(dataArr: [mission.serializeToDictionary()])
                success(mission)
            } else {
                fail(error)
            }
        }
    }
    
    func querryAll(userId: Int64, success: @escaping(Array<PRMissionNoticeModel>) -> (), fail: @escaping(Error?) -> ()) {
        let requestUrl = kPRServerHost+"/mission/queryAll"
        let tmpDic = NSMutableDictionary()
        tmpDic.setValue(NSNumber(value: userId), forKey: "userId")
        PRNetworkTool.shareInstance.request(requestType: .Get, url: requestUrl, parameters: tmpDic as? [String : Any]) { (response, error) in
            if (error == nil && response != nil) {
                var result: Array<PRMissionNoticeModel> = []
                let rList = (response as AnyObject).object(forKey:"result") as! NSArray
                for item in rList {
                    result.append(PRMissionNoticeModel(item as! NSDictionary))
                    print(item)
                }
                success(result)
            } else {
//                fail(error)
            }
        }
    }
    
    func update(mission: PRMissionNoticeModel, success: @escaping(PRMissionNoticeModel) -> (), fail: @escaping(Error?) -> ()) {
        let requestUrl = kPRServerHost+"/mission/update"
        let tmpDic = NSMutableDictionary()
        tmpDic.setValue(NSNumber(value: mission.missionId), forKey: "missionId")
        tmpDic.setValue(NSNumber(value: mission.state.rawValue), forKey: "state")
        tmpDic.setValue(NSNumber(value: mission.deadlineTime), forKey: "deadlineTime")
        tmpDic.setValue(mission.createUserName, forKey: "createUserName")
        tmpDic.setValue(NSNumber(value: mission.completeTime), forKey: "completeTime")
        tmpDic.setValue(NSNumber(value: mission.type.rawValue), forKey: "type")
        tmpDic.setValue(mission.title, forKey: "title")
        tmpDic.setValue(NSNumber(value: mission.createTime), forKey: "createTime")
        if mission.dutyPerson != nil {
            tmpDic.setValue(NSNumber(value: (mission.dutyPerson?.userId)!), forKey: "dutyId")
            tmpDic.setValue(mission.dutyPerson?.userName, forKey: "dutyName")
        } else {
            tmpDic.setValue(PRUserData.profile.userId, forKey: "dutyId")
            tmpDic.setValue(mission.dutyPerson?.userName, forKey: "dutyName")
        }
        tmpDic.setValue(NSNumber(value: mission.createUserId), forKey: "createUserId")
        tmpDic.setValue(NSNumber(value: mission.needClock.rawValue), forKey: "needClock")
        tmpDic.setValue(mission.content, forKey: "content")
        
        PRNetworkTool.shareInstance.request(requestType: .Get, url: requestUrl, parameters: tmpDic as? [String : Any]) { (response, error) in
            if (error == nil && response != nil) {
//                PRMissionsDataMgr.syncData(dataArr: [mission.serializeToDictionary()])
                success(mission)
            } else {
                fail(error)
            }
        }
    }
    
}
