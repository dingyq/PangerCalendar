//
//  PRMineListItem.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/2.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMineListItem: NSObject {
    var imageName: String
    var title: String
    var controllerClassName: String
    
    init(dic: NSDictionary) {
        self.imageName = dic.object(forKey: "CellImage") as! String
        self.title = dic.object(forKey: "CellTitle") as! String
        self.controllerClassName = dic.object(forKey: "ControllerClassName") as! String
        
        super.init()
    }

}
