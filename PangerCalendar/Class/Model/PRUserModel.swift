//
//  PRUserModel.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRUserModel: NSObject {
    let userId:Int64
    var userName:String

    override init() {
        self.userId = -1
        self.userName = ""
        super.init()
    }
    
    init(userId: Int64, name: String) {
        self.userId = userId
        self.userName = name
        super.init()
    }
    
}
