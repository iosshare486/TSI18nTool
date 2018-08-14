//
//  TSUtility.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/17.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
/// 声明协议 增加属性
public protocol TSUtilityCompatible {
    
    associatedtype Compatible
    var ts: Compatible { get }
    
}


/// 通用打印方法
///
/// - Parameters:
///   - message: 打印信息
///   - fileName: 文件名  默认不用写
///   - methodName: 方法名 默认不用写
///   - lineNumber: 所在行数 默认不用写
public func TSLog<T>(_ message: T, fileName: String = #file, methodName: String = #function, lineNumber: Int = #line) -> Void {
    
    #if DEBUG
    let logStr :String = (fileName as NSString).lastPathComponent
    print("类：\(logStr) 方法：\(methodName) 行：[\(lineNumber)] 数据：\(message)")
    
    #endif
}

