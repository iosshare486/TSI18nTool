//
//  TSI18n_ExchangeLanguageViewController.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/27.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SnapKit
import TSCustomUIKit
class TSI18n_ExchangeLanguageViewController: UIViewController {

    var selectLanguage : TSI18nLanguageListModel?
    var dataSource = Array<TSI18nLanguageListModel>(){
        didSet{
            for (_, value) in dataSource.enumerated() {
                if value.wetherDefault == true {
                    self.selectLanguage = value
                    break
                }
            }
            myTableView.reloadData()
        }
    }
    let myTableView = UITableView(frame: .zero)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "语言设置"
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.barTintColor = UIColor.black
        
        
        //完成
        let button1 = UIButton(frame:CGRect(x:0, y:0, width:18, height:18))
        button1.setTitle("完成", for: .normal)
        
        button1.addTarget(self,action:#selector(tapped1),for:.touchUpInside)
        let barButton1 = UIBarButtonItem(customView: button1)
 
        //设置按钮（注意顺序）
        self.navigationItem.rightBarButtonItems = [barButton1]
        
        //取消
        let button2 = UIButton(frame:CGRect(x:0, y:0, width:18, height:18))
        button2.setTitle("取消", for: .normal)
        
        button2.addTarget(self,action:#selector(tapped2),for:.touchUpInside)
        let barButton2 = UIBarButtonItem(customView: button2)
        
        //设置按钮（注意顺序）
        self.navigationItem.leftBarButtonItems = [barButton2]
        
        configViews()
        // Do any additional setup after loading the view.
    }
    @objc func tapped1(){
        view.ts_toast(content: "语言设置成功...")
        ts_i18n_persistence.downloadLanguageSource(url:(selectLanguage?.downloadurl)! ,language: (selectLanguage?.language)!) { (state) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    @objc func tapped2(){
        self.dismiss(animated: true, completion: nil)
        print("取消")
    }
    func configViews() {
        self.view.addSubview(myTableView)
        myTableView.delegate = self
        myTableView.dataSource = self
        myTableView.tableFooterView = UIView()
        self.myTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension TSI18n_ExchangeLanguageViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = TSI18n_ExchangeLanguageListTableViewCell.createCell(tableView: tableView)
        cell.updateCell(model: dataSource[indexPath.row])
        return cell as UITableViewCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //修改选中状态
        for (index, value) in self.dataSource.enumerated() {
            value.wetherDefault = (index == indexPath.row) ? true:false
        }
        selectLanguage = dataSource[indexPath.row]
    }
}








class TSI18nLanguageListModel: NSObject {
    var wetherDefault = false
    var language = "zh_en"
    var version = "2.1.4"
    var languageName = "中文(简体)"
    var downloadurl = "http://p5q287kfg.bkt.clouddn.com/zh-Hans-US.zip"
}

