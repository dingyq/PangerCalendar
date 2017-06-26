//
//  PRCustomTabBarController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRCustomTabBarController: UITabBarController {

    private var screenWidth: CGFloat?
    private var screenHeight: CGFloat?
    
    private let tabBarWidth: CGFloat = 30
    private let tabBarHeight: CGFloat = 30
    private let tabBarViewHeight: CGFloat = 49
    
    private var tabButtons = [UIButton]()
    private var imgArr = ["tab_permanent_nor", "tab_almanac_nor" ,"tab_notice_nor"];
    private var imgSelArr = ["tab_permanent_sel", "tab_almanac_sel", "tab_notice_sel"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let screenFrame = UIScreen.main.bounds
        screenWidth = screenFrame.width
        screenHeight = screenFrame.height
        self.view.backgroundColor = UIColor.white
        self.tabBar.isHidden = true
        self.initViewControllers()
        self.customTabBar()
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

    
    // MARK: - Private Method
    private func customTabBar() {
        let tabBarOffsetX = screenWidth!/3
        let tabBarX = tabBarOffsetX/2 - tabBarWidth/2
        let tabBarY = tabBarViewHeight/2 - tabBarHeight/2 - 6
        
        let tabBarView = PRBaseView(frame: CGRect(x: 0, y: screenHeight! - tabBarViewHeight, width: screenWidth!, height: tabBarViewHeight))
        tabBarView.backgroundColor = UIColor.black
        self.view.addSubview(tabBarView)
        
        for index in 0..<imgArr.count {
            let tabBar_X = (CGFloat)(index) * tabBarOffsetX
            let btn:PRBaseButton = PRBaseButton(frame: CGRect(x: tabBarX + tabBar_X, y: tabBarY, width: tabBarWidth, height: tabBarHeight))
            if(index == 0) {
                btn.setBackgroundImage(PRThemedImage(name: imgSelArr[index]), for: UIControlState.normal)
            } else {
                btn.setBackgroundImage(PRThemedImage(name: imgArr[index]), for: UIControlState.normal)
            }
            
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(tabAction(sender:)), for: UIControlEvents.touchUpInside)
            tabBarView.addSubview(btn)
            tabButtons.append(btn)
        }
        
    }
    
    func tabAction(sender: UIButton){
        let indexSel = sender.tag - 100
        self.selectedIndex = indexSel
        for index in 0..<tabButtons.count {
            if(index == indexSel) {
                tabButtons[index].setBackgroundImage(PRThemedImage(name: imgSelArr[index]), for: UIControlState.normal)
            } else {
                tabButtons[index].setBackgroundImage(PRThemedImage(name: imgArr[index]), for: UIControlState.normal)
            }
        }
    }
    
    private func initViewControllers() {
        let firstTabView = PRPermanentViewController()
        let secondTabView = PRAlmanacViewController()
        let thirdTabView = PRNoticeListViewController()
        
        let viewArr = [firstTabView, secondTabView, thirdTabView]
        var viewCtlArr = [UIViewController]()
        for index in 0..<viewArr.count {
            if(index != 2) {
                let navController = PRNavigationController(rootViewController: viewArr[index])
                viewCtlArr.append(navController)
            } else {
                viewCtlArr.append(viewArr[index])
            }
        }
        
        self.viewControllers = viewCtlArr
    }
}
