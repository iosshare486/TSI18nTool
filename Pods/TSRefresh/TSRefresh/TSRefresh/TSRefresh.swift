//
//  TSRefresh.swift
//  TSRefresh
//
//  Created by 小铭 on 2018/6/21.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

extension UIScrollView {
    /// 添加下拉刷新
    ///
    /// - Parameters:
    ///   - refreshHeader: 下拉刷新动效View必须继承TSRefreshHeader并且要实现TSRefreshHeaderProtocol，不传值的时候默认使用 DefaultGTMRefreshHeader
    ///   - refreshBlock: 刷新数据Block
    @discardableResult
    final public func ts_addRefreshAction(refreshHeader: GTMRefreshHeader? = DefaultGTMRefreshHeader(), refreshBlock:@escaping () -> Void) -> UIScrollView {
        return self.gtm_addRefreshHeaderView(refreshHeader: refreshHeader, refreshBlock: refreshBlock)
    }
    
    
    
    /// 添加上拉加载
    ///
    /// - Parameters:
    ///   - loadMoreFooter: 上拉加载动效View必须继承GTMLoadMoreFooter，不传值的时候默认使用 DefaultGTMLoadMoreFooter
    ///   - refreshBlock: 加载更多数据Block
    @discardableResult
    final public func ts_addLoadMoreAction(loadMoreFooter: GTMLoadMoreFooter? = DefaultGTMLoadMoreFooter(), loadMoreBlock:@escaping () -> Void) -> UIScrollView {
        return self.gtm_addLoadMoreFooterView(loadMoreFooter: loadMoreFooter, loadMoreBlock: loadMoreBlock)
    }
    
    //隐藏和显示上拉加载View
    final public func ts_isShowLoadMore(isShow: Bool) {
        self.gtmFooter?.isHidden = !isShow
    }
    
    // 自定义footer文字
    final public func ts_setupFooterText(pullUpToRefreshText: String? = nil,
                                      loaddingText: String? = nil,
                                      noMoreDataText: String? = nil,
                                      releaseLoadMoreText: String? = nil) {

        guard let defaultFooter = self.value(forKey: "gtmFooter") as? UIView, defaultFooter is DefaultGTMLoadMoreFooter else {
            return
        }
        let footer = defaultFooter as! DefaultGTMLoadMoreFooter
        if let txt = pullUpToRefreshText {
            footer.pullUpToRefreshText = txt
            footer.messageLabel.text = txt
        }
        if let txt = loaddingText {
            footer.loaddingText = txt
        }
        if let txt = noMoreDataText {
            footer.noMoreDataText = txt
        }
        if let txt = releaseLoadMoreText {
            footer.releaseLoadMoreText = txt
        }
    }
    
    final public func ts_triggerRefreshing(){
        self.triggerRefreshing()
    }
    
    final public func ts_endRefreshingAndLoading(isNoMoreData: Bool) {
        if let _ = self.gtmFooter {
            self.endLoadMore(isNoMoreData: isNoMoreData)
        }
        self.endRefreshing(isSuccess: true)
    }
}

