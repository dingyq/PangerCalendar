//
//  PRMissionDetailViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/7/4.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissionDetailViewController: PRBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("提醒详情", comment: "")
        self.resetLeftNavigationItemForPop()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
