//
//  PRDatePickView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/30.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRDatePickView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private var bgPickerView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        
        let button = UIButton()
        self.addSubview(button)
        button.setTitle("", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.setTitleColor(UIColor.red, for: .highlighted)
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
        header.backgroundColor = UIColor.yellow
        header.mas_makeConstraints { (make)  in
            make?.top.leading().trailing().equalTo()(self.bgPickerView)?.setOffset(0)
            make?.height.setOffset(40)
        }

        let datePick = UIDatePicker.init(frame: CGRect.zero)
        datePick.locale = Locale.init(identifier: "zh_CN")
        datePick.timeZone = NSTimeZone.local
        datePick.setDate(Date(), animated: true)
        datePick.maximumDate = Date()
        datePick.datePickerMode = UIDatePickerMode.date
        datePick.addTarget(self, action: #selector(datePickValueChanged), for: .touchUpInside)
        self.bgPickerView.addSubview(datePick)
        
        datePick.mas_makeConstraints { (make) in
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
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        self.bgPickerView.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self)?.setOffset(-260)
        }
        self.removeFromSuperview()
    }
    
}
