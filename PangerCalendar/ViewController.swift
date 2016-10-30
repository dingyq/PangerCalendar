//
//  ViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2016/10/30.
//  Copyright © 2016年 panger. All rights reserved.
//

import UIKit
//import Foundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let result = PRDatabaseOperate.shareMgr().queryDataWithDate(year: "1991", month: "5", day: "25")
        print(result["fit"], result["avoid"])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

//let db = SQLiteDB.sha
