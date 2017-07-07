//
//  PRMissionNoticeModel.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit


enum PRMissionState: Int {
    case new = 0
    case doing = 1
    case done = 2
}

enum PRMissionType: Int {
    case common = 0
    case holiday = 1
    case birthday = 2
    case memorial = 3
}


private func randomInRange(range: Range<Int64>) -> Int64 {
    let count = UInt32(range.upperBound - range.lowerBound)
    return Int64(arc4random_uniform(count)) + range.lowerBound
}

private func randomMissionId() -> Int64 {
    return randomInRange(range: 100000..<9999999)
}


class PRMissionNoticeModel: NSObject {
    var missionId:Int64
    var sortId: Int64
    var type: PRMissionType
    var state: PRMissionState
    var title: String
    var content: String
    var createTime: Double
    var deadlineTime: Double
    var completeTime: Double
    var createUserId: Int64
    var createUserName: String
    var dutyPerson:PRUserModel?
    
    init(_ dic: NSDictionary) {
        self.missionId = Int64("\(dic.object(forKey: "missionId")!)")!
        self.sortId = Int64("\(dic.object(forKey: "sortId")!)")!
        self.type = PRMissionType(rawValue: Int("\(dic.object(forKey: "type")!)")!)!
        self.state = PRMissionState(rawValue: Int("\(dic.object(forKey: "state")!)")!)!
        self.title = dic.object(forKey: "title") as! String
        self.content = dic.object(forKey: "content") as! String
        self.createTime = Double("\(dic.object(forKey: "createTime")!)")!
        self.deadlineTime = Double("\(dic.object(forKey: "deadlineTime")!)")!
        self.completeTime = Double("\(dic.object(forKey: "completeTime")!)")!
        self.createUserId = Int64("\(dic.object(forKey: "createUserId")!)")!
        self.createUserName = dic.object(forKey: "createUserName") as! String
        
        let dutyId = Int64("\(dic.object(forKey: "dutyId")!)")!
        let dutyName = dic.object(forKey: "dutyName") as! String
        self.dutyPerson = PRUserModel(userId: dutyId, name: dutyName)

        super.init()
    }
    
    init(title: String?, _ time: Date?, _ duty: PRUserModel?) {
        self.missionId = randomMissionId()
        self.sortId = -1
        self.type = .common
        self.state = .new
        var tmpTitle = title
        if title == nil {
            tmpTitle = ""
        }
        self.title = tmpTitle!
        self.content = ""
        self.createTime = Double(Date().timeIntervalSince1970)
        if time == nil {
            self.deadlineTime = 0
        } else {
            self.deadlineTime = Double(time!.timeIntervalSince1970)
        }
        self.completeTime = 0
        self.createUserId = PRUserData.profile.userId
        self.createUserName = PRUserData.profile.userName
        self.dutyPerson = duty
        super.init()
    }
    
    init(missionId: Int64, title: String, _ time: Date) {
        self.missionId = missionId
        self.sortId = -1
        self.type = .common
        self.state = .new
        self.title = title
        self.content = ""
        self.createTime = Double(Date().timeIntervalSince1970)
        self.deadlineTime = Double(time.timeIntervalSince1970)
        self.completeTime = 0
        self.createUserId = PRUserData.profile.userId
        self.createUserName = PRUserData.profile.userName
        super.init()
    }
 
    override var description: String {
        let date = Date(timeIntervalSince1970: self.createTime)
        return "missionId=\(missionId) title=\(String(describing: title)) time=\(String(describing: date.yyyyMDDStr()))"
    }
    
    func serializeToDictionary() -> NSDictionary {
        
        let tmpDic = NSMutableDictionary()
        tmpDic.setValue(NSNumber(value: self.missionId), forKey: "missionId")
        tmpDic.setValue(NSNumber(value: self.sortId), forKey: "sortId")
        tmpDic.setValue(NSNumber(value: self.type.rawValue), forKey: "type")
        tmpDic.setValue(NSNumber(value: self.state.rawValue), forKey: "state")
        tmpDic.setValue(self.title, forKey: "title")
        tmpDic.setValue(self.content, forKey: "content")
        tmpDic.setValue(NSNumber(value: self.createTime), forKey: "createTime")
        tmpDic.setValue(NSNumber(value: self.deadlineTime), forKey: "deadlineTime")
        tmpDic.setValue(NSNumber(value: self.completeTime), forKey: "completeTime")
        tmpDic.setValue(NSNumber(value: self.createUserId), forKey: "createUserId")
        tmpDic.setValue(self.createUserName, forKey: "createUserName")
        if self.dutyPerson != nil {
            tmpDic.setValue(NSNumber(value: (self.dutyPerson?.userId)!), forKey: "dutyId")
            tmpDic.setValue(self.dutyPerson?.userName, forKey: "dutyName")
        }
        
        return tmpDic
    }
    
    func isTimeOut() -> Bool {
        return (self.deadlineTime != 0 && self.deadlineTime < Double(Date().timeIntervalSince1970))
    }
    
    func stateDescription() -> String {
        let descriptionArr = ["进行中", "超期", "待办", "已完成"]
        var des = ""
        switch self.state {
        case .new:
            if self.isTimeOut() {
                des = descriptionArr[1]
            } else {
                des = descriptionArr[2]
            }
        case .doing:
            des = descriptionArr[0]
        case .done:
            des = descriptionArr[3]
        }
        return des
    }
    
}
