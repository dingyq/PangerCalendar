//
//  PRMineViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/27.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit


private class PRMineTVCell: PRBaseTableViewCell {
    fileprivate static let reuseId = "PRMineTVCell"
    
    private var tipImageView = PRBaseImageView()
    private var titleLabel = PRBaseLabel()
    private var moreImageView = PRBaseImageView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(tipImageView)
        self.addSubview(titleLabel)
        self.addSubview(moreImageView)
        moreImageView.image = PRThemedImage(name: "more_data_nor")
        
        self.setupViewsLayout()
    }
    
    private func setupViewsLayout() {
        tipImageView.mas_makeConstraints { (make) in
            make?.left.setOffset(10)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
        
        titleLabel.mas_makeConstraints { (make) in
            make?.left.equalTo()(self.tipImageView.mas_right)?.setOffset(6)
            make?.centerY.setOffset(0)
            make?.width.mas_lessThanOrEqualTo()(240)
        }
        
        moreImageView.mas_makeConstraints { (make) in
            make?.right.setOffset(-10)
            make?.centerY.setOffset(0)
            make?.width.and().height().setOffset(20)
        }
    }
    
    func bindData(model: PRMineListItem!) {
        self.tipImageView.image = PRThemedImage(name: model.imageName)
        self.titleLabel.text = model.title
        self.moreImageView.isHidden = !model.hasMoreData
    }
}

class PRMineViewController: PRBaseViewController {
    
    private var mineListTV = PRBaseTableView()
    fileprivate var mineListArr: Array<PRMineListItem>!

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
        self.view.addSubview(mineListTV)
        mineListTV.separatorStyle = .none
        mineListTV.mas_makeConstraints { (make) in
            make?.left.and().right().setOffset(0)
            make?.bottom.setOffset(0)
            make?.top.setOffset(0)
        }
        mineListTV.delegate = self
        mineListTV.dataSource = self
        mineListTV.register(PRMineTVCell.self, forCellReuseIdentifier: PRMineTVCell.reuseId)
    }
}

extension PRMineViewController: UITableViewDelegate, UITableViewDataSource {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: PRMineTVCell.reuseId) as! PRMineTVCell
        cell.bindData(model: self.mineListArr[indexPath.row])
        return cell
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
