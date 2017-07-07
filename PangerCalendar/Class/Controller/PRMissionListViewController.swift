//
//  PRMissionListViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private protocol PRMissionTVCellDelegate: NSObjectProtocol {
    func stateChanged(mission: PRMissionNoticeModel?)
}
private extension PRMissionTVCellDelegate {
    func stateChanged(mission: PRMissionNoticeModel?) {
        print("missionModelStateChanged")
    }
}


class PRMissionTVCell: PRBaseTableViewCell {
    
    private var checkButton: PRBaseButton!
    private var titleLabel: PRBaseLabel!
    private var timeLabel: PRBaseLabel!
    private var dutyLabel: PRBaseLabel!
    private var seperatorLine: PRBaseView!
    private var missionModel: PRMissionNoticeModel?
    weak fileprivate var delegate: PRMissionTVCellDelegate?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let btn = PRBaseButton()
        self.addSubview(btn)
        btn.addTarget(self, action: #selector(self.checkButtonClicked), for: .touchUpInside)
        btn.mas_makeConstraints { (make) in
            make?.left.setOffset(0)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(40)
        }
        self.checkButton = btn
        
        let label = PRBaseLabel()
        self.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.equalTo()(btn.mas_right)?.setOffset(-3)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(240)
        }
        self.titleLabel = label
        
        let label1 = PRBaseLabel()
        self.addSubview(label1)
        label1.mas_makeConstraints { (make) in
            make?.left.equalTo()(label.mas_right)?.setOffset(6)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(72)
        }
        self.dutyLabel = label1
        
        let label2 = PRBaseLabel()
        self.addSubview(label2)
        label2.mas_makeConstraints { (make) in
            make?.left.equalTo()(label1.mas_right)?.setOffset(6)
            make?.centerY.setOffset(0)
        }
        self.timeLabel = label2
        
        let borderView = PRBorderView()
        self.addSubview(borderView)
        borderView.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
            make?.right.setOffset(0)
            make?.height.setOffset(1)
            make?.bottom.setOffset(0)
        }
        self.seperatorLine = borderView
        
    }
    
    @objc private func checkButtonClicked(sender: PRBaseButton) {
        if self.missionModel != nil {
            switch self.missionModel!.state {
            case .new:
                self.missionModel!.state = .doing
                break
            case .doing:
                self.missionModel!.state = .done
                break
            case .done:
                self.missionModel!.state = .new
                break
            }
            self.updateView()
            PRUserData.markMissionDataEdited()
            self.delegate?.stateChanged(mission: self.missionModel)
        }
    }
    
    private func updateView() {
        var imageName = "button_misson_state_fresh"
        var textColor = PRCurrentTheme().blackCustomColor
        if self.missionModel != nil {
            switch self.missionModel!.state {
            case .new:
                imageName = "button_misson_state_fresh"
                if (self.missionModel!.deadlineTime != 0 && self.missionModel!.deadlineTime < Double(Date().timeIntervalSince1970)) {
                    imageName = "button_misson_state_timeout"
                    textColor = PRCurrentTheme().redCustomColor
                }
                break
            case .doing:
                imageName = "button_misson_state_doing"
                textColor = PRCurrentTheme().greenCustomColor
                break
            case .done:
                imageName = "button_misson_state_done"
                textColor = PRCurrentTheme().blackCustomLightColor
                break
            }
        }
        self.checkButton.setImage(PRThemedImage(name: imageName), for: .normal)
        self.checkButton.setImage(PRThemedImage(name: imageName), for: .highlighted)
        self.titleLabel.textColor = textColor
        self.dutyLabel.textColor = textColor
        self.timeLabel.textColor = textColor
    }
 
    func bindData(model: PRMissionNoticeModel!, hideSeperator: Bool) {
        self.missionModel = model
        self.titleLabel.text = model.title
        self.dutyLabel.text = model.dutyPerson?.userName
        if model.deadlineTime > 0 {
            self.timeLabel.text = Date(timeIntervalSince1970: model.deadlineTime).mDDStr()
        } else {
            self.timeLabel.text = ""
        }
        self.updateView()
        self.seperatorLine.isHidden = hideSeperator
    }
}


class PRMissionListViewController: PRBaseViewController, UITableViewDelegate, UITableViewDataSource, PRMissionTVCellDelegate {
    
    private var tbDataSource: Array<Array<PRMissionNoticeModel>> = []
    private var noticeListTV: PRBaseTableView!
    
    private lazy var addMissionNoticeVC: PRMissionAddViewController = {
        var tmpAddVC = PRMissionAddViewController()
        return tmpAddVC
    }()
    
    private lazy var missionEditVC: PRMissionEditViewController = {
        var tmpMissionVC = PRMissionEditViewController()
        tmpMissionVC.hidesBottomBarWhenPushed = true
        return tmpMissionVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("提醒", comment: "") 
        self.setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if PRUserData.isMissionDataEdited() {
            self.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        let addBtn = PRBaseButton()
        addBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        addBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        addBtn.setImage(PRThemedImage(name:"add_notice_button_nor"), for: .normal)
        addBtn.setImage(PRThemedImage(name:"add_notice_button_sel"), for: .highlighted)
        addBtn.setTitleColor(UIColor.black, for: .normal)
        addBtn.setTitleColor(UIColor.black, for: .highlighted)
        addBtn.addTarget(self, action: #selector(self.addButtonClicked), for: .touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: addBtn)
        self.navigationItem.rightBarButtonItem = btnItem
        
        let listTV = PRBaseTableView()
        self.noticeListTV = listTV
        self.view.addSubview(listTV)
        listTV.separatorStyle = .none
        listTV.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.setOffset(0)
            make?.top.setOffset(0)
        }
        listTV.delegate = self
        listTV.dataSource = self
    }
    
    private func reloadData() {
        self.updateTBDataSource()
        self.noticeListTV.reloadData()
    }
    
    private func updateTBDataSource() {
        self.tbDataSource.removeAll()
        let tmpArr = PRUserData.missionClassifiedList()
        for arr in tmpArr {
            if arr.count > 0 {
                self.tbDataSource.append(arr)
            }
        }
    }
    
    // MARK: Private Method (Action)
    @objc private func addButtonClicked(sender: UIButton) {
        self.addMissionNoticeVC.deadlineDate = Date()
        self.addMissionNoticeVC.dutyPerson = PRUserData.profile
        let navController = PRNavigationController(rootViewController: self.addMissionNoticeVC)
        self.present(navController, animated: true, completion: nil)
    }

    // MARK: Protocol Method(PRMissionTVCellDelegate)
    
    func stateChanged(mission: PRMissionNoticeModel?) {
        if mission == nil {
            return
        }
        self.reloadData()
    }
    
    // MARK: Protocol Method(UITableViewDelegate/UITableViewDataSource)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tbDataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.tbDataSource.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 16
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PRBaseView()
        view.backgroundColor = PRCurrentTheme().grayColor247
        let label = PRBaseLabel()
        label.textAlignment = .left
        label.font = PRCurrentTheme().smallFont
        view.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.setOffset(6)
            make?.top.and().bottom().setOffset(0)
        }
        let arr = self.tbDataSource[section]
        if arr.count > 0 {
            label.text = arr.first?.stateDescription()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "missionCellView"
        var cell: PRMissionTVCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PRMissionTVCell
        if cell == nil {
            cell = PRMissionTVCell(style: .default, reuseIdentifier: identifier)
            cell?.delegate = self
        }
        let arr = self.tbDataSource[indexPath.section]
        cell!.bindData(model: arr[indexPath.row], hideSeperator:(arr.count == indexPath.row + 1))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.missionEditVC.editingMission = self.tbDataSource[indexPath.section][indexPath.row]
        self.navigationController?.pushViewController(self.missionEditVC, animated: true)
    }
    
}
