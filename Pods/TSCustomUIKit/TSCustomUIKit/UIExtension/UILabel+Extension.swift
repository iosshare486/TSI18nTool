//
//  UILabel+Extension.swift
//  iOSQuizzes
//
//  Created by 任鹏杰 on 2018/1/3.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//

import UIKit

public extension UILabel {
        
    convenience public init(text: String?,
                     textColor: UIColor?,
                     textFont: UIFont?){
        
        self.init()
        
        self.text = text
        
        if let color = textColor {
            
            self.textColor = color
        }
        
        if let font = textFont {
            
            self.font = font
        }
    }
}


public extension TSUIKit where TU: UILabel {
    
    /// 设置间距
    ///
    /// - Parameter space: 间距
    public func setLineSpace(space: CGFloat) -> Void {
        
        let paraph = NSMutableParagraphStyle()
        
        paraph.lineSpacing = space
        
        let attr = [NSAttributedStringKey.paragraphStyle: paraph]
        
        self.base.attributedText = NSAttributedString.init(string: self.base.text ?? "", attributes: attr)
    }
    
}


public extension TSUIKit where TU: UILabel {
    
    /// 富文本
    ///
    /// - Parameters:
    ///   - text: 数据
    ///   - attributeParms: 模型数组
    public func attributeText(text: String, attributeParms: Array<TSAttributeTextParms>) {
        
        guard text.count > 0 else {
            self.base.text = ""
            return
        }
        let attributeStr: NSMutableAttributedString = NSMutableAttributedString(string: text)
        
        for attributeParm in attributeParms {
            
            if attributeParm.range?.location != NSNotFound {
                
                if attributeParm.color != nil {
                    
                    attributeStr.addAttribute(NSAttributedStringKey.foregroundColor, value: attributeParm.color!, range: attributeParm.range!)
                }
                
                if attributeParm.font != nil {
                    
                    attributeStr.addAttribute(NSAttributedStringKey.font, value: attributeParm.font!, range: attributeParm.range!)
                }
                if attributeParm.lineSpace != nil {
                    
                    let style = NSMutableParagraphStyle()
                    style.lineSpacing = attributeParm.lineSpace!
                    style.alignment = .left
                    style.lineBreakMode = .byWordWrapping
                    attributeStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.count-1))
                }
                
                if attributeParm.rowHeight != nil {
                    
                    let style = NSMutableParagraphStyle()
                    style.minimumLineHeight = attributeParm.rowHeight!
                    style.alignment = .left
                    style.lineBreakMode = .byWordWrapping
                    attributeStr.addAttribute(NSAttributedStringKey.paragraphStyle, value: style, range: NSMakeRange(0, text.count-1))
                }
                
            }
            
        }
        
        self.base.attributedText = attributeStr
    }
    
    /// 根据标记改变文字颜色
    ///
    /// - Parameters:
    ///   - text: 数据
    ///   - beginTag: 开始标记
    ///   - endTag: 结束标记
    ///   - color: 颜色
    public func attributeText(text:String?, beginTag: String, endTag:String, color:UIColor) {
        
        guard text != nil && (text?.count)! > 0 else {
            self.base.text = ""
            return
        }
        
        let ranges: Array = getRange(text: text!, beginTag: beginTag, endTag: endTag)
        
        var params: Array<TSAttributeTextParms> = Array<TSAttributeTextParms>()
        
        for range in ranges {
            
            let param = TSAttributeTextParms.attribute(range: range, color: color)
            params.append(param)
        }
        
        var tempText = text?.replacingOccurrences(of: beginTag, with: "")
        
        tempText = tempText?.replacingOccurrences(of: endTag, with: "")
        
        self.attributeText(text: tempText!, attributeParms: params)
        
    }
    
    /// 将数组中每一元素组合生成字符串并根据是否含有标记判断色值
    ///
    /// - Parameters:
    ///   - texts: 原数组
    ///   - tag: 颜色标记
    ///   - joinSeparate: 拼接字符串
    ///   - color: 颜色
    public func attributeText(texts: [String], tag: String, joinSeparate:String, color: UIColor) {
        
        //先找到需要变色的item
        var tempTexts = [String]()
        for item in texts {
            
            if item.contains(tag) {
                
                let tempItem = String(format: "%@#", item)
                tempTexts.append(tempItem)
            }else{
                tempTexts.append(item)
            }
        }
        
        self.attributeText(text: tempTexts.joined(separator: joinSeparate), beginTag: tag, endTag: "#", color: color)
    }
    
    /// 获取起始标记的位置
    private func getRange(text:String, beginTag: String, endTag:String) -> Array<NSRange> {
        
        let str: NSMutableString = NSMutableString(string: text)
        
        var ranges = Array<NSRange>()
        
        var range: NSRange = NSMakeRange(0, 0)
        
        var start = false
        
        var i = -1
        
        for _ in 0..<str.length{
            i += 1
            if i >= str.length {
                
                break
            }
            let s = str.substring(with: NSMakeRange(i, 1))
            
            if (s == beginTag) {
                if (start) {
                    
                    ranges.append(range)
                }
                start = true;
                range.location = i;
                range.length = 0;
                str.deleteCharacters(in: NSMakeRange(i, 1))
                i -= 1;
                continue;
                
            } else if (s == endTag){
                if (start) {
                    str.deleteCharacters(in: NSMakeRange(i, 1))
                    i -= 1;
                    ranges.append(range)
                    start = false;
                }
            } else {
                if (start) {
                    range.length += 1;
                    if (i == (str.length - 1)) {
                        ranges.append(range)
                    }
                }
            }
            
        }
        return ranges;
    }
    
    
}

/// 设置label富文本的数据模型
public struct TSAttributeTextParms{
    
    public var range: NSRange?
    public var color: UIColor?
    public var font: UIFont?
    public var lineSpace: CGFloat?
    public var rowHeight: CGFloat?
    public static func attribute(range: NSRange, color: UIColor) -> TSAttributeTextParms{
        
        var attribute: TSAttributeTextParms = TSAttributeTextParms()
        attribute.color = color
        attribute.range = range
        
        return attribute
    }
    
    public static func attribute(range: NSRange, font: UIFont) -> TSAttributeTextParms{
        
        var attribute: TSAttributeTextParms = TSAttributeTextParms()
        attribute.font = font
        attribute.range = range
        
        return attribute
    }
    
    public static func attribute(range: NSRange, color: UIColor, font: UIFont) -> TSAttributeTextParms{
        
        var attribute: TSAttributeTextParms = TSAttributeTextParms()
        attribute.color = color
        attribute.range = range
        attribute.font = font
        return attribute
    }
    
    public static func attribute(range: NSRange, color: UIColor, lineSpace: CGFloat) -> TSAttributeTextParms{
        
        var attribute: TSAttributeTextParms = TSAttributeTextParms()
        attribute.color = color
        attribute.range = range
        attribute.lineSpace = lineSpace
        return attribute
    }
    
    public static func attribute(range: NSRange, color: UIColor, rowHeight: CGFloat) -> TSAttributeTextParms{
        
        var attribute: TSAttributeTextParms = TSAttributeTextParms()
        attribute.color = color
        attribute.range = range
        attribute.rowHeight = rowHeight
        return attribute
    }
}

