//
//  TSUtilityDevice.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/20.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public protocol TSUtilityCompatibleDevice: TSUtilityCompatible { }

extension TSUtilityCompatibleDevice {
    public var ts: TSUtilityDevice<Self> {
        get { return TSUtilityDevice(self) }
    }
}

public final class TSUtilityDevice<Base> {
    
    private let base: Base
    public init(_ base: Base) {
        self.base = base
    }
}

extension UIDevice: TSUtilityCompatibleDevice { }

extension TSUtilityDevice where Base: UIDevice {
    
    /// 是否是iPhone X
    public var isIPhoneX: Bool {
        if UIScreen.main.bounds.height == 812 {
            return true
        }
        return false
    }
    
    ///获取应用版本号
    public var appVersion: String {
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            let version = infoDictionary["CFBundleShortVersionString"]
            return version as! String
        }
        return ""
    }
    
    ///获取应用版本号
    public var appName: String {
        
        let infoDictionary = Bundle.main.infoDictionary
        if let infoDictionary = infoDictionary {
            if let name = infoDictionary["CFBundleDisplayName"] {
                return name as! String
            }
        }
        return ""
        
    }
    
    /// 判断系统版本与指定版本的大小
    ///
    /// - Parameter compareVersion: 指定版本
    /// - Returns: true表示系统版本大于等于指定版本
    public func systemVersionGreaterThanOrEqualTo (_ compareVersion: String) -> Bool {
        
        if UIDevice.current.systemVersion.ts.versionCompare(compareVersion) == ComparisonResult.orderedAscending {
            return false
        }
        return true
    }
    
    /// 设备型号
    public var deviceName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = (element.value as? Int8), value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1":                               return "iPhone 7"
        case "iPhone9,2":                               return "iPhone 7 Plus"
        case "iPhone10,1":                              return "iPhone 8"
        case "iPhone10,2":                              return "iPhone 8 Plus"
        case "iPhone10,3":                              return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro"
        case "AppleTV5,3":                              return "Apple TV"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}

extension UINavigationBar: TSUtilityCompatibleDevice { }
extension TSUtilityDevice where Base: UINavigationBar {
    
    public var navBarHeight: CGFloat {
        
        return UIDevice().ts.isIPhoneX ? 88.0 : 64.0
    }
    
}
extension UITabBar: TSUtilityCompatibleDevice { }
extension TSUtilityDevice where Base: UITabBar {
    
    public var tabBarHeight: CGFloat {
        
        return UIDevice().ts.isIPhoneX ? 83.0 : 49.0
    }
    
}










