//
//  UIView+Extension.swift
//  Athena
//
//  Created by 任鹏杰 on 2018/6/28.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//

import UIKit

extension UIView: TSUIKitProtocol {}

public extension TSUIKit where TU: UIView {

    public var x: CGFloat {
        
        set {
            
            var frame = self.base.frame
            frame.origin.x = newValue
            self.base.frame = frame
        }
        
        get {
            
            return self.base.frame.origin.x
        }
    }
    
    
     public var y: CGFloat {
        
        set {

            var frame = self.base.frame
            frame.origin.y = newValue
            self.base.frame = frame
        }
        
        get {
            
            return self.base.frame.origin.y
        }
    }
    
    public var width: CGFloat {
        
        set {
            
            var frame = self.base.frame
            frame.size.width = newValue
            self.base.frame = frame
        }
        
        get {
            
            return self.base.frame.size.width
        }
    }

    public var height: CGFloat {
        
        set {
            
            var frame = self.base.frame
            frame.size.height = newValue
            self.base.frame = frame
        }
        
        get {
            
            return self.base.frame.size.height
        }
    }
    
    public var size: CGSize {
        
        set {
            
            var frame = self.base.frame
            frame.size = newValue
            self.base.frame = frame
        }
        
        get {

            return self.base.frame.size
        }
    }
    
    public var centerX: CGFloat {
        
        set {
            
            var center = self.base.center
            center.x = newValue
            self.base.center = center
        }
        
        get {
            
            return self.base.center.x
        }
    }
    
    public var centerY: CGFloat {
        
        set {
            
            var center = self.base.center
            center.y = newValue
            self.base.center = center
        }
        
        get {
            
            return self.base.center.y
        }
    }
    
    /**
     设置圆角
     */
    public func setCornerRadius(radius: CGFloat) -> Void {
        
        self.base.layer.masksToBounds = true
        self.base.layer.cornerRadius = radius
    }
    
    
    /// 添加指定圆角
    ///
    /// - Parameters:
    ///   - corners: 圆角类型，多个的时候用[]
    ///   - cornerSize: 圆角大小
    public func setAppointCornerRadius(corners: UIRectCorner, cornerSize: CGSize? = nil) -> Void {
        
        let radius = (self.base.tu.width > self.base.tu.height ? self.base.tu.height : self.base.tu.width) / 2
        
        let path = UIBezierPath(roundedRect: self.base.bounds, byRoundingCorners: corners, cornerRadii: cornerSize ?? CGSize(width: radius, height: radius))
        
        let maskLayer = CAShapeLayer()
        
        maskLayer.path = path.cgPath
        
        maskLayer.frame = self.base.bounds
        self.base.layer.mask = maskLayer

    }

    /**
     转化为图片
     */
    public func convertToImage() -> UIImage? {
        
        UIGraphicsBeginImageContextWithOptions(self.base.bounds.size, false, UIScreen.main.scale)
        
        self.base.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}
