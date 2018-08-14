//
//  UIImage+TSUIKit.swift
//  TSSegmentedControl
//
//  Created by huangyuchen on 2018/6/28.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public extension UIImage {
    
    /// 获取渐变色图片 T 只能是Int 或 String
    ///
    /// - Parameters:
    ///   - width: 宽度
    ///   - height: 高度
    ///   - rgbColor: 渐变色值数组 [0x333333, 0xffffff] 只能传Int或String
    ///   - locations: 渐变值区域
    /// - Returns: 返回图片
    convenience public init?<T> (width: CGFloat, height: CGFloat, withRGBValue rgbColor: [T], gradualAreaScale locations: [CGFloat] = [0,1]) {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: width, height: height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.fill(rect)
        
        var colors: [CGFloat] = []
        
        if type(of: T.self) == type(of: Int.self){
            
            for rgb in rgbColor {
                
                let r: CGFloat = CGFloat(CGFloat(((rgb as! Int) & 0xFF0000) >> 16)/255.0)
                let g: CGFloat = CGFloat(CGFloat(((rgb as! Int) & 0xFF00) >> 8)/255.0)
                let b: CGFloat = CGFloat(CGFloat((rgb as! Int) & 0xFF)/255.0)
                
                colors.append(r)
                colors.append(g)
                colors.append(b)
                colors.append(1)
            }
        }else if type(of: T.self) == type(of: String.self) {
            
            for rgb in rgbColor {
                
                var cstring = rgb as! String
                
                if (rgb as! String).contains("#") {
                    
                    let index = cstring.index(cstring.startIndex, offsetBy: 1)
                    cstring = String(cstring[index..<cstring.endIndex])
                }
                
                if cstring.count != 6 {
                    return nil
                }
                
                let rgbVaule = Int(strtoul(cstring, nil, 16))
                
                let r: CGFloat = CGFloat(CGFloat((rgbVaule & 0xFF0000) >> 16)/255.0)
                let g: CGFloat = CGFloat(CGFloat((rgbVaule & 0xFF00) >> 8)/255.0)
                let b: CGFloat = CGFloat(CGFloat(rgbVaule & 0xFF)/255.0)
                
                colors.append(r)
                colors.append(g)
                colors.append(b)
                colors.append(1)
            }
            
        }
        
        guard colors.count > 0 else {
            
            return nil
        }
        
        //使用rgb颜色空间
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        //颜色数组（这里使用三组颜色作为渐变）fc6820
        let compoents:[CGFloat] = colors
        //每组颜色所在位置（范围0~1)
        //生成渐变色（count参数表示渐变个数）
        let gradient = CGGradient(colorSpace: colorSpace, colorComponents: compoents,
                                  locations: locations, count: locations.count)!
        
        //渐变开始位置
        let start = CGPoint(x: 0, y: 0)
        //渐变结束位置
        let end = CGPoint(x: width, y: height)
        //绘制渐变
        context?.drawLinearGradient(gradient, start: start, end: end,
                                    options: .drawsBeforeStartLocation)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let cgimage = image?.cgImage {
            self.init(cgImage: cgimage)
        }else {
            return nil
        }
    }
    
    /// 根据颜色生成图片
    ///
    /// - Parameter color: color
    convenience public init (color: UIColor) {
        
        let rect = CGRect(x: 0.0, y: 0.0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        if let cgimage = image?.cgImage {
            self.init(cgImage: cgimage)
        }else {
            self.init()
        }
    }
    
    /// 截图
    ///
    /// - Parameter view: 需要截图的view
    convenience public init(screenView view: UIView) {
        
        UIGraphicsBeginImageContextWithOptions(view.bounds.size, true, UIScreen.main.scale)
        
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        if let cgimage = image!.cgImage {
            self.init(cgImage: cgimage)
        }else {
            self.init()
        }
    }
    
    /// 根据data生成tabarItem图片，并将图片压缩3倍
    ///
    /// - Parameter data: data
    /// - Returns: data生成图片
    class public func createTarBarItemImage(data: Data) -> UIImage? {
        
        var image = UIImage.init(data: data)
        
        image = UIImage.init(cgImage: (image?.cgImage)!, scale: (image?.scale)! * 3, orientation: (image?.imageOrientation)!)
        
        //防止系统渲染
        image = image?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        
        return image
    }
}
