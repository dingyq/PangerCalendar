//
//  PRDatePickView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/30.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

protocol PRDatePickViewDelegate : NSObjectProtocol {
    func datePickDone(date: Date)
}

class PRDatePickView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    weak var delegate: PRDatePickViewDelegate?
    
    private var bgPickerView: UIView!
    private var datePick: UIDatePicker!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        
        let button = UIButton()
        self.addSubview(button)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(hiddenClick), for: .touchUpInside)
        button.mas_makeConstraints { (make) in
            make?.top.bottom().leading().trailing().equalTo()(self)?.setOffset(0)
        }
        
        self.bgPickerView = UIView()
        self.addSubview(self.bgPickerView)
        self.bgPickerView.backgroundColor = UIColor.white
        self.bgPickerView.mas_makeConstraints { (make) in
            make?.bottom.leading().trailing().equalTo()(self)?.setOffset(-260)
            make?.height.setOffset(260)
        }
        
        let header = UIView()
        self.bgPickerView.addSubview(header)
        header.mas_makeConstraints { (make)  in
            make?.top.leading().trailing().equalTo()(self.bgPickerView)?.setOffset(0)
            make?.height.setOffset(40)
        }
        
        let cancelBtn = UIButton()
        header.addSubview(cancelBtn)
        cancelBtn.titleLabel?.font = PRTheme.current().defaultFont
        cancelBtn.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        cancelBtn.setTitle(NSLocalizedString("取消", comment: ""), for: .highlighted)
        cancelBtn.setTitleColor(UIColor.black, for: .normal)
        cancelBtn.setTitleColor(UIColor.black, for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(hiddenClick), for: .touchUpInside)
        cancelBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(header.mas_centerY)?.setOffset(0)
            make?.leading.equalTo()(header.mas_leading)?.setOffset(6)
            make?.height.setOffset(26)
            make?.width.setOffset(50)
        }

        let confirmBtn = UIButton()
        header.addSubview(confirmBtn)
        confirmBtn.titleLabel?.font = PRTheme.current().defaultFont
        confirmBtn.setTitle(NSLocalizedString("确定", comment: ""), for: .normal)
        confirmBtn.setTitle(NSLocalizedString("确定", comment: ""), for: .highlighted)
        confirmBtn.setTitleColor(UIColor.black, for: .normal)
        confirmBtn.setTitleColor(UIColor.black, for: .highlighted)
        confirmBtn.addTarget(self, action: #selector(datePickedConfirm), for: .touchUpInside)
        confirmBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(header.mas_centerY)?.setOffset(0)
            make?.trailing.equalTo()(header.mas_trailing)?.setOffset(-6)
            make?.height.setOffset(26)
            make?.width.setOffset(50)
        }

        self.datePick = UIDatePicker.init(frame: CGRect.zero)
        self.datePick.minimumDate = Date.appMinDate()
        self.datePick.maximumDate = Date.appMaxDate()
        self.datePick.locale = Locale.init(identifier: "zh_CN")
        self.datePick.timeZone = NSTimeZone.local
        self.datePick.setDate(Date(), animated: true)
        self.datePick.datePickerMode = UIDatePickerMode.date
        self.datePick.addTarget(self, action: #selector(datePickValueChanged), for: .touchUpInside)
        self.bgPickerView.addSubview(self.datePick)
        
        self.datePick.mas_makeConstraints { (make) in
            make?.bottom.leading().trailing().equalTo()(self.bgPickerView)?.setOffset(0)
            make?.top.equalTo()(header.mas_bottom)?.setOffset(0)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func datePickValueChanged() {
        
    }
    
    func show() {
        UIApplication.shared.keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.3) {
            self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0.3)
            self.bgPickerView.mas_updateConstraints { (make) in
                make?.bottom.leading().trailing().equalTo()(self)?.setOffset(0)
                make?.height.setOffset(260)
            }
        }
    }
    
    func hiddenClick(sender: UIButton) {
        self.hide()
    }

    func datePickedConfirm(sender: UIButton) {
        self.delegate?.datePickDone(date: self.datePick.date)
        self.hide()
    }
    
    private func hide() {
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        self.bgPickerView.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self)?.setOffset(-260)
        }
        self.removeFromSuperview()
    }
}
