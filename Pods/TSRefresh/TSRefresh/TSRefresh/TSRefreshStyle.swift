//
//  TSRefreshStyle.swift
//  TSRefresh
//
//  Created by 小铭 on 2018/6/21.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit

extension UIScrollView {
    
    // MARK: - 自定义 header 文字
    @discardableResult
    final public func ts_pullDownToRefreshText(_ text: String) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.pullDownToRefresh = text
        }
        return self
    }
    @discardableResult
    final public func ts_releaseToRefreshText(_ text: String) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.releaseToRefresh = text
        }
        return self
    }
    @discardableResult
    final public func ts_refreshSuccessText(_ text: String) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.refreshSuccess = text
        }
        return self
    }
    @discardableResult
    final public func ts_refreshFailureText(_ text: String) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.refreshFailure = text
        }
        return self
    }
    @discardableResult
    final public func ts_refreshingText(_ text: String) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.refreshing = text
        }
        return self
    }
    
    
    //MARK: - 自定义 footer 文字
    @discardableResult
    final public func ts_pullUpToRefreshText(_ text: String) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.pullUpToRefreshText = text
        }
        return self
    }
    @discardableResult
    final public func ts_loaddingText(_ text: String) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.loaddingText = text
        }
        return self
    }
    @discardableResult
    final public func ts_noMoreDataText(_ text: String) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.noMoreDataText = text
        }
        return self
    }
    @discardableResult
    final public func ts_releaseLoadMoreText(_ text: String) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.releaseLoadMoreText = text
        }
        return self
    }
    
    //MARK: - 自定义文字颜色
    @discardableResult
    final public func ts_headerTextColor(_ color: UIColor) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.txtColor = color
        }
        return self
    }
    @discardableResult
    final public func ts_footerTextColor(_ color: UIColor) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.txtColor = color
        }
        return self
    }
    
    //MARK: - 自定义文图片
    // header's
    @discardableResult
    final public func ts_headerIdleImage(_ image: UIImage?) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.idleImage = image
        }
        return self
    }
    @discardableResult
    final public func ts_headerSucImage(_ image: UIImage?) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.sucImage = image
        }
        return self
    }
    @discardableResult
    final public func ts_headerFailImage(_ image: UIImage?) -> UIScrollView {
        if let header = self.gtmHeader as? DefaultGTMRefreshHeader {
            header.failImage = image
        }
        return self
    }
    // footer's
    @discardableResult
    final public func ts_footerIdleImage(_ image: UIImage?) -> UIScrollView {
        if let footer = self.gtmFooter as? DefaultGTMLoadMoreFooter {
            footer.idleImage = image
        }
        return self
    }
    
}
