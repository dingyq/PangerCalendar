//
//  PRCurrentMonthTitleView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/29.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

protocol PRCurrentMonthTitleViewDelegate : NSObjectProtocol {
    func titleViewClicked()
    func backToToday()
}

class PRCurrentMonthTitleView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate: PRCurrentMonthTitleViewDelegate?
    
    private var monthLabel: PRBaseLabel!
    private var foldImageTip: PRBaseImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let monthBtn = PRBaseButton()
        monthBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        monthBtn.adjustsImageWhenHighlighted = false
        monthBtn.adjustsImageWhenDisabled = false
        monthBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        monthBtn.setTitleColor(UIColor.white, for: UIControlState.selected)
        monthBtn.addTarget(self, action: #selector(monthButtonPressed), for: .touchUpInside)
        self.addSubview(monthBtn)
        
        self.monthLabel = PRBaseLabel()
        self.monthLabel.backgroundColor = UIColor.clear
        self.monthLabel.textAlignment = NSTextAlignment.center
        self.monthLabel.font = UIFont.systemFont(ofSize: 18)
        self.monthLabel.isUserInteractionEnabled = false
        self.addSubview(self.monthLabel)
        
        let imgTip = PRBaseImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
        imgTip.isUserInteractionEnabled = false
        imgTip.image = PRThemedImage(name: "calendar_more_unfold")
        self.addSubview(imgTip)
        self.foldImageTip = imgTip
        
        monthBtn.mas_makeConstraints { (make) in
            make?.top.bottom().leading().trailing().equalTo()(self)?.setOffset(0)
        }
        
        self.monthLabel.mas_makeConstraints { (make) in
            make?.centerX.equalTo()(self.mas_centerX)?.setOffset(-10)
            make?.centerY.equalTo()(self.mas_centerY)?.setOffset(0)
        }
        
        imgTip.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(self.monthLabel.mas_centerY)?.setOffset(0)
            make?.leading.equalTo()(self.monthLabel.mas_trailing)?.setOffset(5)
            make?.height.setOffset(15.0)
            make?.width.setOffset(15.0)
        }
        
        let todayBtn = UIButton()
        todayBtn.titleLabel?.font = PRTheme.current().defaultFont
        todayBtn.setImage(PRThemedImage(name: "button_today_nor"), for: .normal)
        todayBtn.setImage(PRThemedImage(name: "button_today_sel"), for: .highlighted)
        todayBtn.addTarget(self, action: #selector(todayButtonClicked), for: .touchUpInside)
        self.addSubview(todayBtn)
        todayBtn.mas_makeConstraints { (make) in
            make?.trailing.equalTo()(self)?.setOffset(0)
            make?.centerY.equalTo()(self)?.setOffset(0)
            make?.width.height().setOffset(40)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func todayButtonClicked(sender: UIButton) {
        self.delegate?.backToToday()
    }
    
    func update(date: Date?) {
        if date == nil {
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        let strDate = formatter.string(from: date!)
        self.monthLabel.text = strDate
    }
    
    func monthButtonPressed(sender: UIButton) {
        self.delegate?.titleViewClicked()
    }
}
