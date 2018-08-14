//
//  UITextField+Extension.swift
//  Athena
//
//  Created by 任鹏杰 on 2018/8/1.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//

import UIKit

public extension TSUIKit where TU: UITextField {
    
    
    /// 设置占位文字颜色、字体
    /// 需要在设置placeholder文字之后设置
    /// - Parameters:
    ///   - textColor: 占位文字颜色（默认为输入框文字颜色或UIColor.darkText）
    ///   - font: 占位文字字体 （默认输入框文字大小或者14）
   public func setPlaceholder(with textColor: UIColor?, font: UIFont?) -> Void {
        
        var attrTextColor = textColor
        
        if textColor == nil {
            
            if let textColor = self.base.textColor {
                
                attrTextColor = textColor
            }else{
                
                attrTextColor = UIColor.darkText
            }
        }
        
        var attrTextFont = font
        
        if attrTextFont == nil {
            
            if let textFont = self.base.font {
                
                attrTextFont = textFont
            }else{
                
                attrTextFont = UIFont.systemFont(ofSize: 14)
            }
        }

        let attrStr = NSAttributedString.init(string: self.base.placeholder ?? "", attributes: [
                NSAttributedStringKey.foregroundColor : attrTextColor!, NSAttributedStringKey.font : attrTextFont!])
        
        self.base.attributedPlaceholder = attrStr
    }
}
