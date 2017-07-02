//
//  PRMineViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit


private class PRMineTVCell: PRBaseTableViewCell {
    
    private var tipImageView: PRBaseImageView!
    private var titleLabel: PRBaseLabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        let imageV = PRBaseImageView()
        self.addSubview(imageV)
        imageV.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
        self.tipImageView = imageV
        
        let label = PRBaseLabel()
        self.addSubview(label)
        label.mas_makeConstraints { (make) in
            make?.left.equalTo()(imageV.mas_right)?.setOffset(6)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(240)
        }
        self.titleLabel = label
        
        let imageV1 = PRBaseImageView()
        self.addSubview(imageV1)
        imageV1.mas_makeConstraints { (make) in
            make?.right.setOffset(-10)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
        imageV1.image = PRThemedImage(name: "more_data_nor")
    }
    
    func bindData(model: PRMineListItem!) {
        //        let str = "\(model.content ?? "")  \(model.dutyPerson?.userName ?? "") \(model.time?.mDDStr() ?? "")"
        self.tipImageView.image = PRThemedImage(name: model.imageName)
        self.titleLabel.text = model.title
//        self.dutyLabel.text = model.dutyPerson?.userName
//        self.timeLabel.text = Date(timeIntervalSince1970: model.createTime).mDDStr()
    }
}

class PRMineViewController: PRBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var mineListTV: PRBaseTableView!
    private var mineListArr: Array<Array<PRMineListItem>>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("我的", comment: "")
        self.mineListArr = []
        
        let path = Bundle.main.path(forResource: "MeConfigList", ofType: "plist")
        assert(path != nil, "缺失配置文件: MeConfigList.plist")
        let configArr = NSArray(contentsOfFile: path!)
        
        for subArr in configArr! {
            var tmpArr = [PRMineListItem]()
            for dic in subArr as! NSArray {
                let model = PRMineListItem(dic: dic as! NSDictionary)
                tmpArr.append(model)
            }
            self.mineListArr.append(tmpArr)
        }
        
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    
    private func setupViews() {
        let listTV = PRBaseTableView()
        self.mineListTV = listTV
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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.mineListArr.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mineListArr[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "missionCellView"
        var cell: PRMineTVCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PRMineTVCell
        if cell == nil {
            cell = PRMineTVCell(style: .default, reuseIdentifier: identifier)
        }
        cell!.bindData(model: self.mineListArr[indexPath.section][indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item: PRMineListItem = self.mineListArr[indexPath.section][indexPath.row]
        
        let className = Bundle.main.infoDictionary!["CFBundleName"] as! String + "." + item.controllerClassName
        let aClass = NSClassFromString(className) as! UIViewController.Type
        let vc = aClass.init()
        vc.title = item.title
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
