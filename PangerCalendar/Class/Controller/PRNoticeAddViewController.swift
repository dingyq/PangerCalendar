//
//  PRNoticeAddViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/24.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

enum PRMissonItemViewType: Int {
    case none = 0
    case duty = 1
    case time = 2
}


protocol PRMissonItemViewDelegate: NSObjectProtocol {
    func pickTargetData(sender: PRMissonItemView)
    func clearTargetData(sender: PRMissonItemView)
}

class PRMissonItemView: PRBaseView {
    weak var delegate: PRMissonItemViewDelegate?
    var type: PRMissonItemViewType
    private var tipLabel: PRBaseLabel!
    private var tipImageView: PRBaseImageView!
    private var clearButton: PRBaseButton!
    
    init(frame: CGRect, imageName: String) {
        self.type = PRMissonItemViewType.none
        super.init(frame: frame)
        self.setupViews()
        self.updateTipImage(imageName)
    }
    
    override init(frame: CGRect) {
        self.type = PRMissonItemViewType.none
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let lineBottomeView = PRBaseView()
        self.addSubview(lineBottomeView)
        lineBottomeView.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.equalTo()(self)?.setOffset(0)
            make?.height.setOffset(1)
            
        }
        lineBottomeView.backgroundColor = PRTheme.current().borderLineColor
        
        let tipImage = PRBaseImageView()
        self.addSubview(tipImage)
        tipImage.mas_makeConstraints { (make) in
            make?.left.equalTo()(self)?.setOffset(8)
            make?.centerY.equalTo()(self.mas_centerY)?.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
        self.tipImageView = tipImage
        
        let tip = PRBaseLabel()
        self.addSubview(tip)
        tip.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.mas_left)?.setOffset(40)
            make?.right.equalTo()(self.mas_right)?.setOffset(-40)
            make?.top.and().bottom().equalTo()(self)?.setOffset(0)
            make?.centerY.equalTo()(self.mas_centerY)?.setOffset(0)
        }
        tip.textAlignment = .left
        tip.font = PRCurrentTheme().bigFont
        tip.textColor = PRCurrentTheme().blackCustomColor
        self.tipLabel = tip
        
        let pickButton = PRBaseButton()
        self.addSubview(pickButton)
        pickButton.addTarget(self, action: #selector(self.pickButtonClicked), for: .touchUpInside)
        pickButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.mas_left)?.setOffset(40)
            make?.right.equalTo()(self.mas_right)?.setOffset(-40)
            make?.top.and().bottom().equalTo()(self)?.setOffset(0)
            make?.centerY.equalTo()(self.mas_centerY)?.setOffset(0)
        }
        
        let clearBtn = PRBaseButton()
        self.addSubview(clearBtn)
        clearBtn.isHidden = true
        clearBtn.setImage(PRThemedImage(name:"close_button_nor"), for: .normal)
        clearBtn.setImage(PRThemedImage(name:"close_button_sel"), for: .highlighted)
        clearBtn.addTarget(self, action: #selector(self.clearButtonClicked), for: .touchUpInside)
        clearBtn.mas_makeConstraints { (make) in
            make?.right.equalTo()(self.mas_right)?.setOffset(-8)
            make?.width.and().height().setOffset(20)
            make?.centerY.equalTo()(self.mas_centerY)?.setOffset(0)
        }
        self.clearButton = clearBtn
    }
    
    @objc private func clearButtonClicked(sender: PRBaseButton) {
        self.updateTipText("")
        self.delegate?.clearTargetData(sender: self)
    }
    
    @objc private func pickButtonClicked(sender: PRBaseButton) {
        self.delegate?.pickTargetData(sender: self)
    }
    
    // MARK: Public Method
    func updateTipText(_ timeStr: String?) {
        var str = ""
        if timeStr != nil {
            str = timeStr!
        }
        self.clearButton.isHidden = str.isEmpty
        if str.isEmpty {
            switch self.type {
            case .time:
                str = "没有截止时间"
                break
            case .duty:
                str = ""
                break
            default: break
                
            }
        }
        
        self.tipLabel.text = str
    }
    
    func updateTipImage(_ name: String?) {
        self.tipImageView.image = PRThemedImage(name: name)
    }
}


class PRNoticeAddViewController: PRBaseViewController, PRDatePickViewDelegate, PRMissonItemViewDelegate {
    private var _misstionDate: Date?
    var misstionDate: Date? {
        set(newDate) {
            if _misstionDate != newDate {
                _misstionDate = newDate
                self.timeTipView?.updateTipText(newDate?.yyyyMDDStr())
            }
        }
        
        get {
            return _misstionDate
        }
    }
    
    private var dutyPerson: PRUserModel?
    
    private var contentTextField: PRBaseTextField!
    private var dutyTipView: PRMissonItemView!
    private var timeTipView: PRMissonItemView!
    
    private lazy var datePickerView: PRDatePickView = {
        var pickView = PRDatePickView(frame: UIScreen.main.bounds)
        pickView.delegate = self
        return pickView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新建提醒"
        self.view.backgroundColor = PRCurrentTheme().bgColor
        self.resetNavigationItem()
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Method
    
    private func setupViews() {
        let contentView = PRBaseView()
        self.view.addSubview(contentView)
        weak var weakSelf = self
        contentView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(weakSelf?.view)?.setOffset(0)
            make?.top.equalTo()(weakSelf?.view)?.setOffset(65)
            make?.height.setOffset(200)
        }
        
        let text = PRBaseTextField()
        contentView.addSubview(text)
        self.contentTextField = text
        text.layer.cornerRadius = 2
        text.layer.borderWidth = 1
        text.layer.borderColor = PRCurrentTheme().borderLineColor.cgColor
        text.placeholder = "任务内容"
        text.font = PRCurrentTheme().bigFont
        text.textColor = PRCurrentTheme().blackCustomColor
        text.mas_makeConstraints { (make) in
            make?.left.equalTo()(contentView.mas_left)?.setOffset(6)
            make?.right.equalTo()(contentView.mas_right)?.setOffset(-6)
            make?.top.equalTo()(contentView.mas_top)?.setOffset(2)
            make?.height.setOffset(40)
        }

        let lineHeight: CGFloat = 40
        let dutyTip = PRMissonItemView(frame: CGRect.zero, imageName: "account_filling")
        contentView.addSubview(dutyTip)
        dutyTip.type = .duty
        dutyTip.delegate = self;
        dutyTip.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.height.setOffset(lineHeight)
            make?.top.equalTo()(text.mas_bottom)?.setOffset(5)
        }
        self.dutyTipView = dutyTip
        
        // set up time view
        self.timeTipView = PRMissonItemView(frame: CGRect.zero, imageName: "time_clock")
        contentView.addSubview(self.timeTipView!)
        self.timeTipView.type = .time
        self.timeTipView.delegate = self;
        self.timeTipView.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.top.equalTo()(dutyTip.mas_bottom)?.setOffset(0)
            make?.height.setOffset(lineHeight)
        }
        self.timeTipView?.updateTipText(self.misstionDate?.yyyyMDDStr())
        
        // set up add Button
        let addButton = PRBaseButton()
        contentView.addSubview(addButton)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = PRCurrentTheme().redCustomColor.cgColor
        addButton.layer.cornerRadius = 3
        addButton.titleLabel?.font = PRCurrentTheme().bigFont
        addButton.setTitleColor(PRCurrentTheme().blackCustomColor, for: .normal)
        addButton.setTitleColor(PRCurrentTheme().blackCustomColor, for: .highlighted)
        addButton.setTitle("添加提醒", for: .normal)
        addButton.setTitle("添加提醒", for: .highlighted)
        addButton.addTarget(self, action: #selector(self.addNoticeButtonClicked), for: .touchUpInside)
        addButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(contentView.mas_left)?.setOffset(100)
            make?.right.equalTo()(contentView.mas_right)?.setOffset(-100)
            make?.height.setOffset(32)
            make?.bottom.equalTo()(contentView)?.setOffset(0)
        }
    }
    
    private func resetNavigationItem() {
        let backBtn = PRBaseButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.setImage(PRThemedImage(name:"back_button_nor"), for: .normal)
        backBtn.setImage(PRThemedImage(name:"back_button_sel"), for: .highlighted)
//        backBtn.setTitleColor(PRCurrentTheme().blackCustomColor, for: .normal)
//        backBtn.setTitleColor(PRCurrentTheme().blackCustomColor, for: .highlighted)
        backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = btnItem
    }
    
    // MARK: Private Method(Action)
    
    @objc private func backButtonClicked(sender: UIButton?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addNoticeButtonClicked(sender: UIButton) {
        self.contentTextField.resignFirstResponder()
        let content = self.contentTextField.text
        if (content?.isEmpty)! {
            return
        }
        let result = PRUserData.add(missonNotice: PRMissionNoticeModel(content: self.contentTextField.text, self.misstionDate))
        if result {
            self.contentTextField.text = ""
            self.backButtonClicked(sender: nil)
        }
        
    }
    
    // MARK: Protocol Method(PRDatePickViewDelegate)
    func datePickDone(date: Date) {
        self.misstionDate = date
    }
    
    // MARK: Protocol Method(PRMissonItemViewDelegate)
    func pickTargetData(sender: PRMissonItemView) {
        self.contentTextField.resignFirstResponder()
        
        if sender == self.timeTipView {
            self.datePickerView.show()
        } else if sender == self.dutyTipView {
            
        }
        
    }
    
    func clearTargetData(sender: PRMissonItemView) {
        self.contentTextField.resignFirstResponder()
        if sender == self.timeTipView {
            self.misstionDate = nil
        } else if sender == self.dutyTipView {
            self.dutyPerson = nil
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
