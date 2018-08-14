//
//  TSPageControllerHelper.swift
//  TSSegmentedControl
//
//  Created by huangyuchen on 2018/6/28.
//  Copyright © 2018年 caiqr. All rights reserved.
//
import Foundation
import UIKit
import TSUtility

@objc public protocol TSPageViewControllerDelegate: UIPageViewControllerDelegate {
    
    /// 当前选中的controller
    ///
    /// - Parameter index: 位置下标
    @objc optional func pageViewControllerSelectItem(index: Int)
}

public class TSPageControllerHelper: NSObject {
    
    /// pageViewController选中页面后的回调代理
    weak var delegate: TSPageViewControllerDelegate?
    /// 当前选中的index
    private var currentIndex: Int = 0
    //传入pageViewController
    private var pageViewController: UIPageViewController!
    
    private var viewControllers: [UIViewController] = [UIViewController]()
    
    /// 获取pageViewController
    ///
    /// - Parameters:
    ///   - controllers: 子控制器数组
    ///   - parent: 父控制器
    /// - Returns: pageViewController
    public func createPageViewController(_ controllers: [UIViewController], parent: UIViewController)-> UIPageViewController {
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        if let parentcontroller = parent as? TSPageViewControllerDelegate {
            self.delegate = parentcontroller
        }else {
            TSLog("TSPageContainerHelper: parent is not TSPageViewControllerDelegate")
        }
        parent.addChildViewController(pageViewController)
        pageViewController.didMove(toParentViewController: parent)
        self.viewControllers = controllers
        if controllers.count > self.currentIndex {
            pageViewController.setViewControllers([controllers[self.currentIndex]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
        }else {
            TSLog("TSPageController: controllers 为空")
        }
        return pageViewController
    }
    
    /// 修改选中项
    ///
    /// - Parameter index: 位置下标
    public func pageViewControllerSelectIndex(index: Int) {
        
        if index < self.viewControllers.count {
            
            if index < currentIndex {
                self.pageViewController.setViewControllers([self.viewControllers[index]], direction: UIPageViewControllerNavigationDirection.reverse, animated: true, completion: nil)
            }else{
                self.pageViewController.setViewControllers([self.viewControllers[index]], direction: UIPageViewControllerNavigationDirection.forward, animated: true, completion: nil)
            }
            self.currentIndex = index
        }else {
            TSLog("TSPageController: index 越界")
        }
        
    }
}

extension TSPageControllerHelper: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        var index = self.viewControllers.index(of: viewController )
        
        if index == self.viewControllers.count - 1 || index == nil {
            
            return nil
        }
        
        index! += 1
        self.currentIndex = index!
        if index! < self.viewControllers.count {
            
            return self.viewControllers[index!]
        }else {
            
            TSLog("TSPageController: index 越界")
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = self.viewControllers.index(of: viewController)
        
        if index == 0 || index == nil {
            
            return nil
        }
        
        index! -= 1
        self.currentIndex = index!
        if index! < self.viewControllers.count {
            
            return self.viewControllers[index!]
        }else {
            
            TSLog("TSPageController: index 越界")
        }
        return nil
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        currentIndex = self.viewControllers.index(of: pendingViewControllers.first!) ?? 0
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if completed {
            
            if let vc = pageViewController.viewControllers?.last, let index = self.viewControllers.index(of: vc)  {
                self.currentIndex = index
            }
            self.delegate?.pageViewControllerSelectItem?(index: self.currentIndex)
        }
        
    }
}
