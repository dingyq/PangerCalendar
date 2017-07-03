//
//  PRBaseViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/24.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRBaseViewController: UIViewController, UIGestureRecognizerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = PRCurrentTheme().bgColor
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Public Method
    
    func resetLeftNavigationItemForDismiss() {
        self.resetLeftNavigationItem(forPop: false)
    }
    
    func resetLeftNavigationItemForPop() {
        self.resetLeftNavigationItem(forPop: true)
    }
    
    func dismissSelf() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func popSelf() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: Private Method
    
    private func resetLeftNavigationItem(forPop: Bool) {
        let backBtn = PRBaseButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.setImage(PRThemedImage(name:"back_button_nor"), for: .normal)
        backBtn.setImage(PRThemedImage(name:"back_button_sel"), for: .highlighted)
        if forPop {
            backBtn.addTarget(self, action: #selector(self.popBackButtonClicked), for: .touchUpInside)
            self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        } else {
            backBtn.addTarget(self, action: #selector(self.dimissBackButtonClicked), for: .touchUpInside)
        }
        let btnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = btnItem
    }
    
    // MARK: Private Method(Action)
    
    @objc private func dimissBackButtonClicked(sender: UIButton?) {
        self.dismissSelf()
    }
    
    @objc private func popBackButtonClicked(sender: UIButton?) {
        self.popSelf()
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
