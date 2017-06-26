//
//  PRNoticeAddViewController.swift
//  PangerCalendar
//
//  Created by bigqiang on 2017/6/24.
//  Copyright © 2017年 panger. All rights reserved.
//

import UIKit

class PRNoticeAddViewController: PRBaseViewController {

    private var missonContentTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "新建提醒"
        self.resetNavigationItem()
        self.setupViews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Private Method
    
    private func setupViews() {
        let contentView = UIView()
//        contentView.backgroundColor = UIColor.red
        self.view.addSubview(contentView)
        weak var weakSelf = self
        contentView.mas_makeConstraints { (make) in
            make?.left.right().equalTo()(weakSelf?.view)?.setOffset(0)
            make?.top.equalTo()(weakSelf?.view)?.setOffset(65)
            make?.height.setOffset(200)
        }
        
        let text = UITextField()
        contentView.addSubview(text)
        self.missonContentTextField = text
        text.layer.cornerRadius = 2
        text.layer.borderWidth = 1
        text.layer.borderColor = UIColor.gray.cgColor
        text.placeholder = "任务内容"
        text.mas_makeConstraints { (make) in
            make?.left.equalTo()(contentView.mas_left)?.setOffset(2)
            make?.right.equalTo()(contentView.mas_right)?.setOffset(-2)
            make?.top.equalTo()(contentView.mas_top)?.setOffset(2)
            make?.height.equalTo()(50)
        }

        let timeButton = UIButton()
        
        contentView.addSubview(timeButton)
        
        
        let addButton = UIButton()
        contentView.addSubview(addButton)
        addButton.layer.borderWidth = 1
        addButton.layer.borderColor = UIColor.init(colorLiteralRed: 1, green: 0, blue: 0, alpha: 1).cgColor
        addButton.layer.cornerRadius = 3
        addButton.layer.backgroundColor = UIColor.green.cgColor
        addButton.setTitle("添加提醒", for: .normal)
        addButton.setTitle("添加提醒", for: .highlighted)
        addButton.addTarget(self, action: #selector(self.addNoticeButtonClicked), for: .touchUpInside)
        addButton.mas_makeConstraints { (make) in
            make?.left.equalTo()(contentView.mas_left)?.setOffset(100)
            make?.right.equalTo()(contentView.mas_right)?.setOffset(-100)
            make?.height.equalTo()(32)
            make?.bottom.equalTo()(contentView)?.setOffset(0)
        }
        
        
    }
    
    private func resetNavigationItem() {
        let backBtn = UIButton()
        backBtn.frame = CGRect(x: 0, y: 0, width: 30, height: 40)
        backBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        backBtn.setImage(UIImage(named:"back_button_nor"), for: .normal)
        backBtn.setImage(UIImage(named:"back_button_sel"), for: .highlighted)
        backBtn.setTitleColor(UIColor.black, for: .normal)
        backBtn.setTitleColor(UIColor.black, for: .highlighted)
        backBtn.addTarget(self, action: #selector(self.backButtonClicked), for: .touchUpInside)
        
        let btnItem = UIBarButtonItem(customView: backBtn)
        self.navigationItem.leftBarButtonItem = btnItem
    }
    
    // MARK: Private Method(Action)
    
    @objc private func backButtonClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func addNoticeButtonClicked(sender: UIButton) {
        PRUserData.add(missonNotice: PRMissionNoticeModel(content: "", nil))
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
