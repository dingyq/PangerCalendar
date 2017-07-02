//
//  PRNoticeListViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/3/25.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRMissionTVCell: PRBaseTableViewCell {
    
    private var contentLabel: PRBaseLabel!
    private var timeLabel: PRBaseLabel!
    private var dutyLabel: PRBaseLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let label = PRBaseLabel()
        self.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
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
        
    }
 
    func bindData(model: PRMissionNoticeModel!) {
//        let str = "\(model.content ?? "")  \(model.dutyPerson?.userName ?? "") \(model.time?.mDDStr() ?? "")"
        self.contentLabel.text = model.content
        self.dutyLabel.text = model.dutyPerson?.userName
        self.timeLabel.text = Date(timeIntervalSince1970: model.createTime).mDDStr()
    }
}


class PRNoticeListViewController: PRBaseViewController, UITableViewDelegate, UITableViewDataSource {

    private var noticeListTV: PRBaseTableView!
    
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

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: Protocol Method(UITableViewDelegate/UITableViewDataSource)
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PRUserData.missonList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
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
        cell!.bindData(model: PRUserData.missonList[indexPath.row])
        return cell!
    }
    
}
