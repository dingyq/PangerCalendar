//
//  PRMissionEditViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/7/4.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissionEditViewController: PRMissionDetailViewController {
    
    override func viewDidLoad() {
        self.vcType = .edit
        super.viewDidLoad()
        self.title = NSLocalizedString("提醒详情", comment: "")
        self.resetLeftNavigationItemForPop()
        
        let deleteButton = PRBaseButton()
        deleteButton.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        deleteButton.setImage(PRThemedImage(name:"button_delete_nor"), for: .normal)
        deleteButton.setImage(PRThemedImage(name:"button_delete_sel"), for: .highlighted)
        deleteButton.addTarget(self, action: #selector(self.deleteButtonClicked), for: .touchUpInside)
        let btnItem = UIBarButtonItem(customView: deleteButton)
        self.navigationItem.rightBarButtonItem = btnItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc private func deleteButtonClicked(sender: UIButton) {
        if self.editingMission != nil {
            let _ = PRUserData.remove(mission: self.editingMission!)
            self.popSelf()
        }
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
