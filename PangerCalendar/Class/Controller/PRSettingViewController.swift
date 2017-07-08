//
//  PRSettingViewController.swift
//  PangerCalendar
//
//  Created by yongqiang on 2017/7/2.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

private class PRSettingTVCell: PRBaseTableViewCell {
    fileprivate static let reuseId = "PRSettingTVCell"
    private var titleLabel = PRBaseLabel()
    private var switchButton = UISwitch()
    private var setModel: PRSettingItem!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(titleLabel)
        titleLabel.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(240)
        }
        
        self.addSubview(switchButton)
        switchButton.mas_makeConstraints { (make) in
            make?.right.setOffset(-10)
            make?.centerY.setOffset(0)
        }
        switchButton.addTarget(self, action: #selector(self.switchButtonClicked), for: .touchUpInside)
        
        let borderView = PRBorderView()
        self.addSubview(borderView)
        borderView.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
            make?.bottom.setOffset(0)
            make?.right.setOffset(0)
            make?.height.setOffset(1)
        }
    }
    
    @objc private func switchButtonClicked(sender: UISwitch) {
        self.setModel.switchState = sender.isOn
        UserDefaults.standard.setBool(sender.isOn, forUserStrKey: self.setModel.uuid)
    }
    
    func bindData(model: PRSettingItem!) {
        self.setModel = model
        self.titleLabel.text = model.title
        self.switchButton.setOn(model.switchState!, animated: false)
    }
}

class PRSettingViewController: PRBaseViewController {
    
    private var settingListTV = PRBaseTableView()
    fileprivate var settingConfigList: Array<Array<PRSettingItem>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("设置", comment: "")
        self.resetLeftNavigationItemForPop()
        
        self.settingConfigList = []
        
        let path = Bundle.main.path(forResource: "PRCustomSettingConfig", ofType: "plist")
        assert(path != nil, "缺失配置文件: PRCustomSettingConfig.plist")
        let configArr = NSArray(contentsOfFile: path!)
        
        for subArr in configArr! {
            var tmpArr = [PRSettingItem]()
            for dic in subArr as! NSArray {
                let model = PRSettingItem(dic: dic as! NSDictionary)
                tmpArr.append(model)
            }
            self.settingConfigList.append(tmpArr)
        }
        UserDefaults.standard.setBool(true, forUserStrKey: kPRUserNotFirstLogin)
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func setupViews() {
        self.view.addSubview(settingListTV)
        settingListTV.separatorStyle = .none
        settingListTV.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.setOffset(0)
            make?.top.setOffset(0)
        }
        settingListTV.delegate = self
        settingListTV.dataSource = self
        settingListTV.register(PRSettingTVCell.self, forCellReuseIdentifier: PRSettingTVCell.reuseId)
    }
}

extension PRSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingConfigList.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingConfigList[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20.0
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = PRBaseView()
        let label = PRBaseLabel()
        view.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.setOffset(6)
            make?.centerY.setOffset(0)
        }
        if section == 0 {
            label.text = NSLocalizedString("提醒设置", comment: "")
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return NSLocalizedString("提醒", comment: "")
        }
        return ""
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PRSettingTVCell.reuseId) as! PRSettingTVCell
        cell.bindData(model: self.settingConfigList[indexPath.section][indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
