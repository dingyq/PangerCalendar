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
    private var moreImageView: PRBaseImageView!
    
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
        self.moreImageView = imageV1
    }
    
    func bindData(model: PRMineListItem!) {
        self.tipImageView.image = PRThemedImage(name: model.imageName)
        self.titleLabel.text = model.title
        self.moreImageView.isHidden = !model.hasMoreData
    }
}

class PRMineViewController: PRBaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var mineListTV: PRBaseTableView!
    private var mineListArr: Array<PRMineListItem>!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = NSLocalizedString("我的", comment: "")
        self.mineListArr = []
        
        let path = Bundle.main.path(forResource: "MeConfigList", ofType: "plist")
        assert(path != nil, "缺失配置文件: MeConfigList.plist")
        let configArr = NSArray(contentsOfFile: path!)
        
        for dic in configArr! {
            let model = PRMineListItem(dic: dic as! NSDictionary)
            self.mineListArr.append(model)
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
    
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return self.mineListArr.count
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.mineListArr.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let identifier = "mineCellView"
        var cell: PRMineTVCell? = tableView.dequeueReusableCell(withIdentifier: identifier) as? PRMineTVCell
        if cell == nil {
            cell = PRMineTVCell(style: .default, reuseIdentifier: identifier)
        }
        cell!.bindData(model: self.mineListArr[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let item: PRMineListItem = self.mineListArr[indexPath.row]
        if item.hasMoreData {
            let vc = NSObject.fromClassName(className: item.controllerClassName)
            vc.title = item.title
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            
        }
    }

}
