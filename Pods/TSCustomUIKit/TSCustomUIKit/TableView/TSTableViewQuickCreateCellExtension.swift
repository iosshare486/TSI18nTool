//
//  TSTableViewQuickCreateCellExtension.swift
//  TSKit
//
//  Created by huangyuchen on 2018/7/14.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public protocol ReusableViewProtocol {}

public extension ReusableViewProtocol where Self: UIView {
    
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
}

extension UITableViewCell: ReusableViewProtocol {}
extension UITableViewHeaderFooterView: ReusableViewProtocol {}

public extension UITableView {
    
    public func ts_register<T: UITableViewCell>(_ cellClass: T.Type) {
        
        register(T.classForCoder(), forCellReuseIdentifier: T.reuseIdentifier)
        
    }
    
    public func ts_dequeueReusableCell<T: UITableViewCell>(_ cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier) as? T else {
            
            let cellTemp = T.init(style: UITableViewCellStyle.default, reuseIdentifier: T.reuseIdentifier)
            
            return cellTemp
            
        }
        return cell
    }
    
    public func ts_dequeueReusableHeaderFooter<T: UITableViewHeaderFooterView>(_ cellClass: T.Type) -> T {
        guard let header = dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            
            let headerTemp = T.init(reuseIdentifier: T.reuseIdentifier)
            
            return headerTemp
            
        }
        return header
    }
}
