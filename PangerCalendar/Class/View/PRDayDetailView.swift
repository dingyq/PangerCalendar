//
//  PRDayDetailView.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/26.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRDayDetailView: UIView {
    private var dayLabel: UILabel!
    private var lunarDateLabel: UILabel!
    private var weekLabel: UILabel!
    private var weekIndexLabel: UILabel!
    private var ganzhiLabel: UILabel!
    private var yiLabel: UILabel!
    private var jiLabel: UILabel!
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dayLabel = self.createLabel()
        self.dayLabel.font = UIFont.systemFont(ofSize: 46.0)
        self.dayLabel.textAlignment = NSTextAlignment.center;
        self.dayLabel.textColor = PRTheme.current().redCustomColor
        self.addSubview(self.dayLabel)
        
        self.lunarDateLabel = self.createLabel()
        self.addSubview(self.lunarDateLabel)
        
        self.weekLabel = self.createLabel()
        
        self.addSubview(self.weekLabel)
        
        self.weekIndexLabel = self.createLabel()
        self.addSubview(self.weekIndexLabel)
        
        self.ganzhiLabel = self.createLabel()
        self.addSubview(self.ganzhiLabel)
        
        self.yiLabel = self.createLabel()
        self.addSubview(self.yiLabel)
        
        self.jiLabel = self.createLabel()
        self.addSubview(self.jiLabel)
        
        weak var weakSelf = self
        self.dayLabel.mas_makeConstraints { (make) in
            make?.left.top().equalTo()(weakSelf)?.setOffset(16.0)
            make?.height.setOffset(48)
        }
        self.lunarDateLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf?.dayLabel.mas_right)?.setOffset(5)
            make?.top.equalTo()(weakSelf)?.setOffset(23)
        }
        self.weekLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf?.dayLabel.mas_right)?.setOffset(5)
            make?.top.equalTo()(weakSelf?.lunarDateLabel.mas_bottom)?.setOffset(3)
        }
        self.weekIndexLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf)?.setOffset(16.0)
            make?.top.equalTo()(weakSelf)?.setOffset(90)
//            make?.height.setOffset(20)
        }
        self.ganzhiLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf?.weekIndexLabel.mas_right)?.setOffset(6)
            make?.top.equalTo()(weakSelf)?.setOffset(90)
//            make?.height.setOffset(20)
        }
        self.yiLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf)?.setOffset(16.0)
            make?.right.equalTo()(weakSelf)?.setOffset(-16.0)
            make?.top.equalTo()(weakSelf?.weekIndexLabel.mas_bottom)?.setOffset(5)
//            make?.height.setOffset(20)
        }
        self.jiLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(weakSelf)?.setOffset(16.0)
            make?.right.equalTo()(weakSelf)?.setOffset(-16.0)
            make?.top.equalTo()(weakSelf?.yiLabel.mas_bottom)?.setOffset(6)
//            make?.height.setOffset(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    // MARK: Private Method
    private func createLabel() -> UILabel! {
        let label = UILabel(frame: CGRect.zero)
        label.font = PRTheme.current().defaultFont
        label.textAlignment = NSTextAlignment.left;
        label.textColor = PRTheme.current().blackCustomColor
        return label
    }
    
    // MARK: Public Method
    func update(date: Date?) {
        if date == nil {
            return
        }
        self.dayLabel.text = date?.dayStr()
        self.lunarDateLabel.text = date?.lunarDateStr()
        self.weekLabel.text = date!.weekDayStr()
        self.weekIndexLabel.text = date!.weekOfYearStr()
        self.ganzhiLabel.text = date?.ganZhiZodiacStr()
        self.yiLabel.text = String.init(format:"宜：%@", (date?.yiZuoStr())!)
        self.jiLabel.text = String.init(format:"忌：%@", (date?.jiZuoStr())!)
    }

}
