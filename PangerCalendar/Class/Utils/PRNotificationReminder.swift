//
//  PRNotificationReminder.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/7/9.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private let _default = PRNotificationReminder()

class PRNotificationReminder: NSObject {
    class var `default`: PRNotificationReminder {
        get {
            return _default
        }
    }
    
    var allNotice: Array<UILocalNotification>? {
        get {
            let arr = UIApplication.shared.scheduledLocalNotifications
            return arr
        }
    }
    
    
    func add(mission: PRMissionNoticeModel) {
        let _ = self.remove(mission: mission)
        
        let notify = UILocalNotification()
        notify.alertBody = mission.title
        notify.fireDate = Date(timeIntervalSince1970: mission.deadlineTime)
//                    notify.fireDate = Date().addingTimeInterval(10)
        notify.timeZone = kPRTimeZone
        let dic = mission.briefDictionary()
        notify.userInfo = dic as? [AnyHashable : Any]
        notify.hasAction = true
        notify.alertAction = "确定"
        notify.applicationIconBadgeNumber = 1;
        notify.repeatInterval = .quarter
//        notify.soundName = UILocalNotificationDefaultSoundName
        notify.soundName = "bell_dreamland.caf"
        UIApplication.shared.scheduleLocalNotification(notify)
    }
    
    func remove(mission: PRMissionNoticeModel) -> Bool {
        if self.allNotice != nil {
            for notify in self.allNotice! {
                if notify.userInfo != nil {
                    if Int64("\(notify.userInfo!["missionId"]!)")! == mission.missionId {
                        UIApplication.shared.cancelLocalNotification(notify)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func isNoticeExist(mission: PRMissionNoticeModel) -> Bool {
        if self.allNotice != nil {
            for notify in self.allNotice! {
                if notify.userInfo != nil {
                    if Int64("\(notify.userInfo!["missionId"]!)")! == mission.missionId {
                        return true
                    }
                }
            }
        }
        return false
    }
}
