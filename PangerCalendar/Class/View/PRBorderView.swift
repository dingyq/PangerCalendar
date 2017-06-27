//
//  PRBorderView.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRBorderView: PRBaseView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    
    override func draw(_ rect: CGRect) {
        PRCurrentTheme().borderLineColor.set()
        UIRectFill(rect)
    }


}
