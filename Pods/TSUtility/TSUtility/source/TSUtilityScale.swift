//
//  TSUtilityScale.swift
//  TSUtility
//
//  Created by huangyuchen on 2018/4/19.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

public final class TSUtilityScale<Base> {
    
    private let base: Base
    public init(_ base: Base) {
        self.base = base
    }
    
    public func scale() -> CGFloat {
        
        if type(of: Base.self) == type(of: CGFloat.self) {
            let value: CGFloat = self.base as! CGFloat
            return value * UIScreen.main.bounds.size.width / 375.0
            
        }else if type(of: Base.self) == type(of: Float.self) {
            
            let value: Float = self.base as! Float
            return CGFloat(value) * UIScreen.main.bounds.size.width / 375.0
            
        }else if type(of: Base.self) == type(of: Double.self) {
            
            let value: Double = self.base as! Double
            return CGFloat(value) * UIScreen.main.bounds.size.width / 375.0
        }
        
        return 0
    }
    
}

extension CGFloat: TSUtilityCompatible {
    
    public var ts: TSUtilityScale<CGFloat> {
        
        get { return TSUtilityScale(self) }
    }
}

extension Float: TSUtilityCompatible {
    
    public var ts: TSUtilityScale<Float> {
        
        get { return TSUtilityScale(self) }
    }
}

extension Double: TSUtilityCompatible {
    
    public var ts: TSUtilityScale<Double> {
        
        get { return TSUtilityScale(self) }
    }
}
