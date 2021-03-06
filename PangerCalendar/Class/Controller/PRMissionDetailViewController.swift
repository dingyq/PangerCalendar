//
//  PRMissionDetailViewController.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/6.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit


enum PRMissionDetailVCType: Int {
    case add = 0
    case edit = 1
}

enum PRMissionItemViewType: Int {
    case none = 0
    case duty = 1
    case time = 2
}

protocol PRMissionItemViewDelegate: NSObjectProtocol {
    func pickTargetData(sender: PRMissionItemView)
    func clearTargetData(sender: PRMissionItemView)
}

class PRMissionItemView: PRBaseView {
    weak var delegate: PRMissionItemViewDelegate?
    var type: PRMissionItemViewType
    private var tipLabel: PRBaseLabel!
    private var tipImageView: PRBaseImageView!
    private var clearButton: PRBaseButton!
    
    init(frame: CGRect, imageName: String) {
        self.type = PRMissionItemViewType.none
        super.init(frame: frame)
        self.setupViews()
        self.updateTipImage(imageName)
    }
    
    override init(frame: CGRect) {
        self.type = PRMissionItemViewType.none
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        let borderView = PRBorderView()
        self.addSubview(borderView)
        borderView.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.equalTo()(self)?.setOffset(0)
            make?.height.setOffset(1)
            
        }
        //        lineBottomeView.backgroundColor = PRTheme.current().borderLineColor
        
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
    func updateTipText(_ text: String?) {
        var str = ""
        if text != nil {
            str = text!
        }
        self.clearButton.isHidden = str.isEmpty
        if str.isEmpty {
            switch self.type {
            case .time:
                str = NSLocalizedString("没有截止时间", comment: "")
            case .duty:
                str = NSLocalizedString("选择负责人", comment: "")
            default: break
                
            }
        }
        
        self.tipLabel.text = str
    }
    
    private func updateTipImage(_ name: String?) {
        self.tipImageView.image = PRThemedImage(name: name)
    }
}


// MARK: PRMissionDetailViewController

class PRMissionDetailViewController: PRBaseViewController, PRMissionItemViewDelegate {

    var editingMission: PRMissionNoticeModel?
    
    private var _deadlineDate: Date?
    var deadlineDate: Date? {
        set(newDate) {
            if _deadlineDate != newDate {
                _deadlineDate = newDate
                self.timeTipView?.updateTipText(newDate?.yyyyMDDhhmmStr())
            }
        }
        
        get {
            return _deadlineDate
        }
    }
    
    private var _dutyPerson: PRUserModel?
    var dutyPerson: PRUserModel? {
        set(newPerson) {
            if _dutyPerson != newPerson {
                _dutyPerson = newPerson
                self.dutyTipView?.updateTipText(newPerson?.userName)
            }
        }
        get {
            return _dutyPerson
        }
    }
    
    var vcType = PRMissionDetailVCType.add
    
    private var contentView: PRBaseView?
    private var titleTextField: PRBaseTextField?
    private var contentTextView: PRBaseTextView?
    private var dutyTipView: PRMissionItemView?
    private var timeTipView: PRMissionItemView?
    
    private lazy var timePickerView: PRTimePickerView = {
        var pickView = PRTimePickerView(frame: UIScreen.main.bounds)
        pickView.timePickDone = {[unowned self](date) in
            self.deadlineDate = date
        }
        return pickView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.timeTipView?.updateTipText(self.deadlineDate?.yyyyMDDhhmmStr())
        self.dutyTipView?.updateTipText(self.dutyPerson?.userName)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.vcType == .edit {
            self.updateView(mission: self.editingMission)
        } else if self.vcType == .add {
            self.contentTextView?.text = ""
            self.titleTextField?.text = ""
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: Public Method
    func updateView(mission: PRMissionNoticeModel?) {
        if mission == nil {
            return
        }
        self.titleTextField?.text = mission!.title
        self.contentTextView?.text = mission!.content
        self.dutyPerson = mission!.dutyPerson
        self.deadlineDate = Date(timeIntervalSince1970: mission!.deadlineTime)
    }
    
    // MARK: Private Method
    private func setupViews() {
        let contentView = PRBaseView()
        self.view.addSubview(contentView)
        self.contentView = contentView
        
        weak var weakSelf = self
        contentView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(weakSelf?.view)?.setOffset(0)
            make?.top.equalTo()(weakSelf?.view)?.setOffset(65)
            make?.bottom.setOffset(0)
        }
        
        let textContainer = PRBaseView()
        contentView.addSubview(textContainer)
        textContainer.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.top.setOffset(2)
            make?.height.setOffset(45 + 85)
        }
        
        let text = PRBaseTextField()
        textContainer.addSubview(text)
        self.titleTextField = text
        text.backgroundColor = PRCurrentTheme().bgColor
        text.placeholder = NSLocalizedString("任务标题", comment: "")
        text.mas_makeConstraints { (make) in
            make?.left.setOffset(8)
            make?.right.setOffset(-8)
            make?.top.setOffset(0)
            make?.height.setOffset(40)
        }
        
        var borderView = PRBorderView()
        textContainer.addSubview(borderView)
        borderView.mas_makeConstraints { (make) in
            make?.left.setOffset(8)
            make?.right.setOffset(0)
            make?.top.equalTo()(text.mas_bottom)?.setOffset(1)
            make?.height.setOffset(1)
        }
        
        let text1 = PRBaseTextView()
        textContainer.addSubview(text1)
        self.contentTextView = text1
        text1.backgroundColor = PRCurrentTheme().bgColor
        text1.mas_makeConstraints { (make) in
            make?.left.setOffset(6)
            make?.right.setOffset(-6)
            make?.top.equalTo()(borderView.mas_bottom)?.setOffset(1)
            make?.bottom.setOffset(-2)
        }
        
        borderView = PRBorderView()
        textContainer.addSubview(borderView)
        borderView.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.setOffset(0)
            make?.height.setOffset(1)
        }
        
        
        let lineHeight: CGFloat = 40
        let dutyTip = PRMissionItemView(frame: CGRect.zero, imageName: "account_filling")
        contentView.addSubview(dutyTip)
        dutyTip.type = .duty
        dutyTip.delegate = self;
        dutyTip.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.height.setOffset(lineHeight)
            make?.top.equalTo()(textContainer.mas_bottom)?.setOffset(0)
        }
        self.dutyTipView = dutyTip
        
        // set up time view
        let timeView = PRMissionItemView(frame: CGRect.zero, imageName: "time_clock")
        contentView.addSubview(timeView)
        timeView.type = .time
        timeView.delegate = self;
        timeView.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.top.equalTo()(dutyTip.mas_bottom)?.setOffset(0)
            make?.height.setOffset(lineHeight)
        }
        self.timeTipView = timeView
        
        // set up add Button
        let confirmButton = PRBaseButton()
        contentView.addSubview(confirmButton)
        confirmButton.layer.borderWidth = 1
        confirmButton.layer.borderColor = PRCurrentTheme().redCustomColor.cgColor
        confirmButton.layer.cornerRadius = 3
        var btnTitle = "添加提醒"
        switch self.vcType {
        case .edit:
            btnTitle = "确认修改"
        default:
            break
        }
        confirmButton.setTitle(NSLocalizedString(btnTitle, comment: ""), for: .normal)
        confirmButton.setTitle(NSLocalizedString(btnTitle, comment: ""), for: .highlighted)
        confirmButton.addTarget(self, action: #selector(self.editMissonButtonClicked), for: .touchUpInside)
        confirmButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(contentView.mas_left)?.setOffset(100)
            make?.right.equalTo()(contentView.mas_right)?.setOffset(-100)
            make?.height.setOffset(32)
            make?.top.equalTo()(timeView.mas_bottom)?.setOffset(20)
        }
    }
    
    // MARK: Private Method (Action)
    
    @objc private func editMissonButtonClicked(sender: UIButton) {
        self.view.endEditing(true)
        
        let titleStr = self.titleTextField?.text
        if (titleStr?.isEmpty)! {
            return
        }
        switch self.vcType {
        case .add:
            let mission = PRMissionNoticeModel(title: titleStr, self.deadlineDate, self.dutyPerson)
            mission.content = self.contentTextView!.text
            let result = PRUserData.add(mission: mission)
            if result {
                self.titleTextField?.text = ""
                self.dismissSelf()
            }
        case .edit:
            self.editingMission?.title = titleStr!
            self.editingMission?.content = (self.contentTextView?.text)!
            self.editingMission?.dutyPerson = self.dutyPerson
            var time: Double = 0
            if self.deadlineDate != nil {
                time = Double(self.deadlineDate!.timeIntervalSince1970)
            }
            self.editingMission?.deadlineTime = time
            
            if self.editingMission != nil {
                PRUserData.update(self.editingMission)
                self.popSelf()
            }
        }
    }
    
    // MARK: Protocol Method(PRMissionItemViewDelegate)
    func pickTargetData(sender: PRMissionItemView) {
        self.view.endEditing(true)
        
        if sender == self.timeTipView {
            self.timePickerView.show()
        } else if sender == self.dutyTipView {
            
        }
        
    }
    
    func clearTargetData(sender: PRMissionItemView) {
        self.view.endEditing(true)
        
        if sender == self.timeTipView {
            self.deadlineDate = nil
        } else if sender == self.dutyTipView {
            self.dutyPerson = nil
        }
    }

}
