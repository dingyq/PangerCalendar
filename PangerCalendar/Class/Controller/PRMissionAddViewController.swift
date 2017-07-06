//
//  PRMissionAddViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/24.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit



class PRMissionAddViewController: PRMissionDetailViewController {
    
    override func viewDidLoad() {
        self.vcType = .add
        super.viewDidLoad()
        self.title = NSLocalizedString("新建提醒", comment: "")
        self.resetLeftNavigationItemForDismiss()
    }
}
