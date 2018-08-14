//
//  TSUIKit.swift
//  Athena
//
//  Created by 任鹏杰 on 2018/7/10.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//


public final class TSUIKit<TU> {
    
    public let base: TU
    
    public init(_ base: TU) {
        
        self.base = base
    }
}

public protocol TSUIKitProtocol {
    
    associatedtype type
    var tu: type { get }
}

public extension TSUIKitProtocol {
    
    public var tu: TSUIKit<Self> {
        
        get {
            
            return TSUIKit(self)
        }
    }
}

