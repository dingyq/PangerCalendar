//
//  PRTimePickerView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/7/8.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRTimePickerView: PRBaseView {
    
    var timePickDone: ((_ date: Date) -> Void)?//选择的回调
    fileprivate var dateRange = 0
    fileprivate var selectedDateIndex = 0
    fileprivate var selectedHour = 0
    fileprivate var selectedMinute = 0
    
    private var bgPickerView = UIView()
    private var timePick = UIPickerView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        
        let button = PRBaseButton()
        self.addSubview(button)
        button.setTitle("", for: .normal)
        button.addTarget(self, action: #selector(hiddenClick), for: .touchUpInside)
        button.mas_makeConstraints { (make) in
            make?.top.bottom().leading().trailing().equalTo()(self)?.setOffset(0)
        }
        
        self.addSubview(self.bgPickerView)
        self.bgPickerView.backgroundColor = UIColor.white
        self.bgPickerView.mas_makeConstraints { (make) in
            make?.bottom.leading().trailing().equalTo()(self)?.setOffset(-260)
            make?.height.setOffset(260)
        }
        
        let header = PRBaseView()
        self.bgPickerView.addSubview(header)
        header.mas_makeConstraints { (make)  in
            make?.top.leading().trailing().equalTo()(self.bgPickerView)?.setOffset(0)
            make?.height.setOffset(40)
        }
        
        let cancelBtn = PRBaseButton()
        header.addSubview(cancelBtn)
        cancelBtn.titleLabel?.font = PRTheme.current().defaultFont
        cancelBtn.setTitle(NSLocalizedString("取消", comment: ""), for: .normal)
        cancelBtn.setTitle(NSLocalizedString("取消", comment: ""), for: .highlighted)
        cancelBtn.addTarget(self, action: #selector(hiddenClick), for: .touchUpInside)
        cancelBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(header.mas_centerY)?.setOffset(0)
            make?.leading.equalTo()(header.mas_leading)?.setOffset(6)
            make?.height.setOffset(26)
            make?.width.setOffset(50)
        }
        
        let confirmBtn = PRBaseButton()
        header.addSubview(confirmBtn)
        confirmBtn.titleLabel?.font = PRTheme.current().defaultFont
        confirmBtn.setTitle(NSLocalizedString("确定", comment: ""), for: .normal)
        confirmBtn.setTitle(NSLocalizedString("确定", comment: ""), for: .highlighted)
        confirmBtn.addTarget(self, action: #selector(timePickConfirm), for: .touchUpInside)
        confirmBtn.mas_makeConstraints { (make) in
            make?.centerY.equalTo()(header.mas_centerY)?.setOffset(0)
            make?.trailing.equalTo()(header.mas_trailing)?.setOffset(-6)
            make?.height.setOffset(26)
            make?.width.setOffset(50)
        }
        
        self.timePick.delegate = self
        self.timePick.dataSource = self
        self.bgPickerView.addSubview(self.timePick)
        
        self.timePick.mas_makeConstraints { (make) in
            make?.bottom.leading().trailing().equalTo()(self.bgPickerView)?.setOffset(0)
            make?.top.equalTo()(header.mas_bottom)?.setOffset(0)
        }
        
        self.setupTimePicker()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Public Method
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
    
    // MARK: Private Method
    @objc private func hiddenClick(sender: UIButton) {
        self.hide()
    }
    
    @objc private func timePickConfirm(sender: UIButton) {
        var comp = DateComponents()
        comp.day = self.selectedDateIndex
        let date = Calendar.current.date(byAdding: comp, to: kPRAppMinDate)
        if self.timePickDone != nil {
            self.timePickDone!(date!)
        }
        self.hide()
    }
    
    private func hide() {
        self.backgroundColor = RGBACOLOR(r: 0, 0, 0, 0)
        self.bgPickerView.mas_updateConstraints { (make) in
            make?.bottom.equalTo()(self)?.setOffset(-260)
        }
        self.removeFromSuperview()
    }
    
    private func setupTimePicker() {
        let calendar = Calendar.current
        self.dateRange = calendar.dateComponents([.day], from: kPRAppMinDate, to: kPRAppMaxDate).day!
        self.selectedDateIndex = calendar.dateComponents([.day], from: kPRAppMinDate, to: Date()).day!
        let todayComps = DateComponents.today()
        self.selectedHour = (todayComps.hour! + 1)%24;
        self.selectedMinute = todayComps.minute!;
        
        self.timePick.selectRow(self.selectedDateIndex, inComponent: 0, animated: true)
        self.timePick.selectRow(self.selectedHour, inComponent: 1, animated: true)
        self.timePick.reloadAllComponents()
    }
}

extension PRTimePickerView: UIPickerViewDelegate, UIPickerViewDataSource {
    //MARK:UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    ////确定每一列返回的东西
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch component {
        case 0:
            return self.dateRange
        case 1:
            return 24
        default:
            return 0
        }
    }
    
    //返回一个视图，用来设置pickerView的每行显示的内容。
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        let label  = UILabel(frame: CGRect(x: kPRScreenWidth * CGFloat(component) / 6 , y: 0, width: kPRScreenWidth/6, height: 30))
        label.font = PRCurrentTheme().bigFont
        label.tag = component*100+row
        label.textAlignment = .center
        switch component {
        case 0:
            label.frame=CGRect(x:5, y:0,width:kPRScreenWidth*3.0/4.0, height:30);
            var comp = DateComponents()
            comp.day = row
            let date = Calendar.current.date(byAdding: comp, to: kPRAppMinDate)
            label.text = date?.yyyyMDDStr()
        case 1:
            label.textAlignment = .right
            label.text="\(row )时";
        default:
            label.text="\(row )秒";
        }
        return label
    }
    
    //当点击UIPickerView的某一列中某一行的时候，就会调用这个方法
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch component {
        case 0:
            self.selectedDateIndex = row
        case 1:
            self.selectedHour = row
        default:
            self.selectedHour = row
        }
    }
}
