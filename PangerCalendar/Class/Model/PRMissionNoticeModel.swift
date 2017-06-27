//
//  PRMissionNoticeModel.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private func randomInRange(range: Range<Int>) -> Int {
    let count = UInt32(range.upperBound - range.lowerBound)
    return Int(arc4random_uniform(count)) + range.lowerBound
}

private func randomMissonId() -> Int {
    return randomInRange(range: 100000..<9999999)
}


class PRMissionNoticeModel: NSObject {
    var missonId:Int
    var content:String?
    var time:Date?
    var dutyPerson:PRUserModel?
    
    init(content: String?, _ time: Date?, _ duty: PRUserModel?) {
        self.missonId = randomMissonId()
        self.content = content
        self.time = time
        self.dutyPerson = duty
        super.init()
    }
    
    init(missionId: Int, content: String?, _ time: Date?) {
        self.missonId = missionId
        self.content = content
        self.time = time
        super.init()
    }
 
    override var description: String {
        return "missonId=\(missonId) content=\(String(describing: content)) time=\(String(describing: self.time?.yyyyMDDStr()))"
    }
    
}
