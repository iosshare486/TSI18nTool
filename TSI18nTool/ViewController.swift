//
//  ViewController.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/25.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SnapKit
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backImageView = UIImageView()
        backImageView.tsI18n_id = "back"
        backImageView.backgroundColor = UIColor.red
        view.addSubview(backImageView)
        backImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        backImageView.set_i18n_image()
        
        let contentLabel = UILabel()
        contentLabel.tsI18n_id = "home_activity"
        contentLabel.textColor = UIColor.white
        contentLabel.backgroundColor = UIColor.purple
        contentLabel.set_i18n_text()
        if contentLabel.text?.count == 0 {
            contentLabel.text = "中文"
        }
        view.addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.top.equalToSuperview().offset(100)
        }
        
        let btn = UIButton()
        btn.setTitle("多语言", for: UIControlState.normal)
        btn.backgroundColor = UIColor.blue
        btn.setTitleColor(.white, for: .normal)
        self.view.addSubview(btn)
        
        
        btn.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(60)
        }
        btn.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    @objc func btnClick() {
        ts_i18n_manager.exchangeLanguage(vc: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

