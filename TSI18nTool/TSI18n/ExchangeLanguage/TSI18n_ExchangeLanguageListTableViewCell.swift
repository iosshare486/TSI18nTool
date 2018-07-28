//
//  TSI18n_ExchangeLanguageListTableViewCell.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/27.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SnapKit
class TSI18n_ExchangeLanguageListTableViewCell: UITableViewCell {

    let nameTitle = UILabel()
    let selectState = UIImageView()
    
    class func createCell(tableView:UITableView) -> TSI18n_ExchangeLanguageListTableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "TSI18n_ExchangeLanguageListTableViewCell")
        //如果cell为空就自己创建
        if cell == nil {
            cell = TSI18n_ExchangeLanguageListTableViewCell(style: .default, reuseIdentifier: "TSI18n_ExchangeLanguageListTableViewCell")
        }
        return cell! as! TSI18n_ExchangeLanguageListTableViewCell
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.clear
        backgroundColor = UIColor.clear
//        selectionStyle = .none
        self.configSubviews()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configSubviews() {
        self.contentView.addSubview(nameTitle)
        self.contentView.addSubview(selectState)
        selectState.backgroundColor = UIColor.red
        self.nameTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.bottom.equalToSuperview()
        }
    
        self.selectState.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.width.height.equalToSuperview().multipliedBy(0.5)
        }
    }
    
    
    func updateCell(model:TSI18nLanguageListModel) {
        self.nameTitle.text = model.languageName
        self.selectState.isHidden = !model.wetherDefault
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
