//
//  TSLoadMoreFooter.swift
//  TSRefresh
//
//  Created by 小铭 on 2018/6/26.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

@objc public protocol TSLoadMoreProtocol {
    @objc optional func tsToNormalState()
    @objc optional func tsToNoMoreDataState()
    @objc optional func tsToWillRefreshState()
    @objc optional func tsToRefreshingState()
    
    /// 控件的高度(自定义控件通过该方法设置自定义高度)
    ///
    /// - Returns: 控件的高度
    func tsContentHeith() -> CGFloat
}

class TSLoadMoreFooter: GTMLoadMoreFooter, SubGTMLoadMoreFooterProtocol {
    
    public var tsSubProtocol: TSLoadMoreProtocol? {
        get { return self as? TSLoadMoreProtocol }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }

    func toNormalState() {
        self.tsSubProtocol?.tsToNormalState?()
    }
    func toNoMoreDataState() {
        self.tsSubProtocol?.tsToNoMoreDataState?()
    }
    func toWillRefreshState() {
        self.tsSubProtocol?.tsToWillRefreshState?()
    }
    func toRefreshingState() {
        self.tsSubProtocol?.tsToRefreshingState?()
    }
    
    func contentHeith() -> CGFloat {
        return self.tsSubProtocol?.tsContentHeith() ?? 0
    }
    
}
