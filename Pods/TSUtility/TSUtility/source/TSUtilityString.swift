//
//  TSUtilityString.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
public final class TSUtilityString {
    
    private let base: String
    public init (_ base: String) {
        self.base = base
    }
    
    public func color() -> UIColor {
        
        return self.stringToColor(1.0)
    }
    
    public func color(_ alpha: CGFloat) -> UIColor {
        
        return self.stringToColor(alpha)
    }
    
    public func substring(_ startIndex: Int, _ endIndex: Int) -> String {
        
        if endIndex < startIndex {
            
            debugPrint("endIndex < startIndex")
            return ""
        }
        
        if startIndex >= self.base.count  {
            debugPrint("startIndex >= string.count")
            return ""
        }
        
        if endIndex >= self.base.count  {
            debugPrint("endIndex >= string.count")
            return ""
        }
        
        let startIndex = self.base.index(self.base.startIndex, offsetBy: startIndex)
        let endIndex = self.base.index(self.base.startIndex, offsetBy: endIndex)
        return String(self.base[startIndex...endIndex])
    }
    
    public func versionCompare(_ compareVersion: String) -> ComparisonResult {
        
        //将两个版本号以“.”拆分成数组
        let currentVersions = self.base.components(separatedBy: ".")
        let compareVersions = compareVersion.components(separatedBy: ".")
        //分别比较每一位的大小
        let count = (currentVersions.count < compareVersions.count) ? currentVersions.count : compareVersions.count
        
        for i in 0..<count {
            
            if let current = Int(currentVersions[i]), let compare = Int(compareVersions[i]) {
             
                if current > compare {
                    return ComparisonResult.orderedDescending
                }else if current < compare {
                    return ComparisonResult.orderedAscending
                }
            }
        }
        //经过上面的for后还没有比较出来，说明两者相同位的版本号都相同，剩下的则看谁的版本号更长，长的则表示版本号大。例：11.0.1 < 11.0.1.1
        if currentVersions.count < compareVersions.count {
            return ComparisonResult.orderedAscending
        }else if currentVersions.count > compareVersions.count {
            return ComparisonResult.orderedDescending
        }else {
            return ComparisonResult.orderedSame
        }
    }
}

extension TSUtilityString {
    
    private func stringToColor(_ alpha: CGFloat) -> UIColor {
        
        let rgbValue: String = self.base
        var cString: String = rgbValue.trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines)
        
        if cString.hasPrefix("0x") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 2)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        if cString.hasPrefix("#") {
            let reqIndex = cString.index(cString.startIndex, offsetBy: 1)
            cString = String(cString[reqIndex..<cString.endIndex])
        }
        
        if cString.count == 1 {
            cString = String(format: "%@%@%@%@%@%@", cString, cString, cString, cString, cString, cString)
        }else if cString.count == 2 {
            cString = String(format: "%@%@%@", cString, cString, cString)
        }else if cString.count == 3 {
            cString = String(format: "%@%@", cString, cString)
        }
        
        if cString.count != 6 {
            return UIColor.black
        }
        
        var range: NSRange = NSMakeRange(0, 2)
        let rString = (cString as NSString).substring(with: range)
        range.location = 2
        let gString = (cString as NSString).substring(with: range)
        range.location = 4
        let bString = (cString as NSString).substring(with: range)
        
        var r: UInt32 = 0x0
        var g: UInt32 = 0x0
        var b: UInt32 = 0x0
        Scanner.init(string: rString).scanHexInt32(&r)
        Scanner.init(string: gString).scanHexInt32(&g)
        Scanner.init(string: bString).scanHexInt32(&b)
        
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        } else {
            return UIColor(red: CGFloat(r)/255.0, green: CGFloat(g)/255.0, blue: CGFloat(b)/255.0, alpha: alpha)
        }
    }
}

extension String: TSUtilityCompatible {
    
    public var ts: TSUtilityString {
        get { return TSUtilityString(self) }
    }
}
