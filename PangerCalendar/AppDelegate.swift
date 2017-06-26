//
//  AppDelegate.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        self.window = UIWindow(frame:UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        
        let imgArr = ["tab_permanent_nor", "tab_almanac_nor" ,"tab_notice_nor"];
        let imgSelArr = ["tab_permanent_sel", "tab_almanac_sel", "tab_notice_sel"]
        let titleArr = ["万年历", "黄历", "提醒"]
        let tabBarController = PRTabBarController()
        let vc1 = PRPermanentViewController()
        let vc2 = PRAlmanacViewController()
        let vc3 = PRNoticeListViewController()
        let viewArr = [vc1, vc2, vc3]
        var viewCtlArr = [UIViewController]()
        for index in 0..<viewArr.count {
            let navController = PRNavigationController(rootViewController: viewArr[index])
            navController.tabBarItem.image = UIImage(named: imgArr[index])
            navController.tabBarItem.selectedImage = UIImage(named: imgSelArr[index])
            navController.tabBarItem.title = titleArr[index]
            viewCtlArr.append(navController)
        }
        tabBarController.viewControllers = viewCtlArr
        
//        let nav:PRNavigationController = PRNavigationController(rootViewController: tabBarController)
//        self.window?.rootViewController = nav
        self.window?.rootViewController = tabBarController
        self.window?.makeKeyAndVisible()
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

