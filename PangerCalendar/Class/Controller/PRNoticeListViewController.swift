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
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        let cLabel = PRBaseLabel(frame: CGRect.zero)
        self.addSubview(cLabel)
        cLabel.mas_makeConstraints { (make) in
            make?.left.setOffset(20)
            make?.right.setOffset(-20)
            make?.centerY.setOffset(0)
            make?.height.setOffset(20)
        }
        self.contentLabel = cLabel
    }
 
    func bindData(model: PRMissionNoticeModel!) {
        self.contentLabel.text = model.content
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
