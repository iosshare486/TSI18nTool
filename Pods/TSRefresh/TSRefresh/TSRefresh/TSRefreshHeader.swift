//
//  TSRefreshHeader.swift
//  TSRefresh
//
//  Created by 小铭 on 2018/6/26.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

@objc public protocol TSRefreshHeaderProtocol {
    /// 状态变成.idle
    @objc optional func tsToNormalState()
    /// 状态变成.refreshing
    @objc optional func tsToRefreshingState()
    /// 状态变成.pulling
    @objc optional func tsToPullingState()
    /// 状态变成.willRefresh
    @objc optional func tsToWillRefreshState()
    /// 下拉高度／触发高度 值改变
    @objc optional func tsChangePullingPercent(percent: CGFloat)
    /// 开始结束动画前执行
    @objc optional func tsWillBeginEndRefershing(isSuccess: Bool)
    /// 结束动画完成后执行
    @objc optional func tsWillCompleteEndRefershing()
    
    /// 控件的高度
    ///
    /// - Returns: 控件的高度
    func tsContentHeight() -> CGFloat
}

open class TSRefreshHeader: GTMRefreshHeader , SubGTMRefreshHeaderProtocol{
    
    public var tsSubProtocol: TSRefreshHeaderProtocol? {
        get { return self as? TSRefreshHeaderProtocol }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func toNormalState() {
        self.tsSubProtocol?.tsToNormalState?()
    }
    public func toRefreshingState() {
        self.tsSubProtocol?.tsToRefreshingState?()
    }
    public func toPullingState() {
        self.tsSubProtocol?.tsToPullingState?()
    }
    public func toWillRefreshState() {
        self.tsSubProtocol?.tsToWillRefreshState?()
    }
    public func changePullingPercent(percent: CGFloat) {
        self.tsSubProtocol?.tsChangePullingPercent?(percent: percent)
    }
    public func willBeginEndRefershing(isSuccess: Bool) {
        self.tsSubProtocol?.tsWillBeginEndRefershing?(isSuccess: isSuccess)
    }
    public func willCompleteEndRefershing() {
        self.tsSubProtocol?.tsWillCompleteEndRefershing?()
    }
    
    public func contentHeight() -> CGFloat {
        return self.tsSubProtocol?.tsContentHeight() ?? 0
    }
    
}
