//
//  PRBaseTableView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRBaseTableViewCell: UITableViewCell {
    convenience init() {
        self.init(style: .default, reuseIdentifier: "")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class PRBaseTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init() {
        self.init(frame: CGRect.zero, style: .plain)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}
