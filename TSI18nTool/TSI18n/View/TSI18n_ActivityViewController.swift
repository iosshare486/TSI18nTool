//
//  TSI18n_ActivityViewController.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/30.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SnapKit
class TSI18n_ActivityViewController: UIViewController {

    var activityView = TSI18n_ActivityView.createActivityView()
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(activityView)
        activityView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
