//
//  PRMissionListViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissionTVCell: PRBaseTableViewCell {
    
    private var checkButton: PRBaseButton!
    private var contentLabel: PRBaseLabel!
    private var timeLabel: PRBaseLabel!
    private var dutyLabel: PRBaseLabel!
    private var missionModel: PRMissionNoticeModel?
    
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
            make?.left.setOffset(10)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
        self.checkButton = btn
        
        let label = PRBaseLabel()
        self.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.equalTo()(btn.mas_right)?.setOffset(6)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(240)
        }
        self.contentLabel = label
        
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
        }
        self.updateView()
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
        self.contentLabel.textColor = textColor
        self.dutyLabel.textColor = textColor
        self.timeLabel.textColor = textColor
    }
 
    func bindData(model: PRMissionNoticeModel!) {
        self.missionModel = model
        self.contentLabel.text = model.content
        self.dutyLabel.text = model.dutyPerson?.userName
        self.timeLabel.text = Date(timeIntervalSince1970: model.deadlineTime).mDDStr()
        self.updateView()
    }
}


class PRMissionListViewController: PRBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var noticeListTV: PRBaseTableView!
    
    private lazy var addMissionNoticeVC: PRMissionAddViewController = {
        var tmpAddVC = PRMissionAddViewController()
        return tmpAddVC
    }()
    
    private lazy var missionDetailVC: PRMissionEditViewController = {
        var tmpMissionVC = PRMissionEditViewController()
        return tmpMissionVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("提醒", comment: "") 
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.noticeListTV.reloadData()
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

    
    // MARK: Private Method (Action)
    @objc private func addButtonClicked(sender: UIButton) {
        let navController = PRNavigationController(rootViewController: self.addMissionNoticeVC)
        self.present(navController, animated: true, completion: nil)
    }

    // MARK: Protocol Method(UITableViewDelegate/UITableViewDataSource)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PRUserData.missionList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 36.0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "missionCellView"
        var cell: PRMissionTVCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PRMissionTVCell
        if cell == nil {
            cell = PRMissionTVCell(style: .default, reuseIdentifier: identifier)
        }
        cell!.bindData(model: PRUserData.missionList[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(self.missionDetailVC, animated: true)
    }
    
}
