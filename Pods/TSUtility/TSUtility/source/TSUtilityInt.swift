//
//  TSUtilityInt.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public final class TSUtilityInt {
    
    private let base: Int
    public init (_ base: Int) {
        self.base = base
    }
    
    public func color() -> UIColor {
        
        return self.intToColor(1.0)
    }
    
    public func color(_ alpha: CGFloat) -> UIColor {
        
        return self.intToColor(alpha)
    }
    
    public func scale() -> CGFloat {
    
        return CGFloat(self.base) * UIScreen.main.bounds.size.width / 375.0
    }
    
    public func string() -> String {
        return String(format: "%ld", self.base)
    }
    
    public func font() -> UIFont {
        
        return UIFont.systemFont(ofSize: self.scale())
    }
    
    public func boldFont() -> UIFont {
        
        return UIFont.boldSystemFont(ofSize: self.scale())
    }
}

extension TSUtilityInt {
    
    fileprivate func intToColor(_ alpha: CGFloat) -> UIColor {
        
        let rgbInt: Int = self.base
        
        let rgbString = String(format: "%x", rgbInt)
        if rgbString.count == 6 {
            //如果 是6位16进制数 则直接返回color
            return UIColor(red: ((CGFloat)((rgbInt & 0xFF0000) >> 16)) / 255.0,
                           green: ((CGFloat)((rgbInt & 0xFF00) >> 8)) / 255.0,
                           blue: ((CGFloat)(rgbInt & 0xFF)) / 255.0,alpha: alpha)
        }else {
            
            return rgbString.ts.color(alpha)
        }
    }
}

extension Int: TSUtilityCompatible {
    
    public var ts: TSUtilityInt {
        get { return TSUtilityInt(self) }
    }
}
