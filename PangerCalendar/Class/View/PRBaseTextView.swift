//
//  PRBaseTextView.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/7.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRBaseTextView: UITextView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        self.setDefaultParams()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setDefaultParams() {
        self.font = PRCurrentTheme().bigFont
        self.textColor = PRCurrentTheme().blackCustomColor
    }

}
