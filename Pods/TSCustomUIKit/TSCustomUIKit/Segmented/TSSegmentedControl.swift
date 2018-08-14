//
//  TSSegmentedControl.swift
//  TSSegmentedControl
//
//  Created by huangyuchen on 2018/6/26.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import TSUtility
import SnapKit

@objc public class TSSegmentedControlTitleItem: NSObject {
    
    /// 普通文字
    public var normalTitle: String?
    /// 选中文字
    public var selectTitle: String?
    /// 文字 普通时颜色
    public var normalColor: UIColor? = 0x9.ts.color()
    /// 文字 选中时颜色
    public var selectColor: UIColor? = 0xff5050.ts.color()
    /// 文字 普通时大小
    public var normalFont: UIFont? = 15.ts.font()
    /// 文字 选中时大小
    public var selectFont: UIFont? = 15.ts.font()
    /// 普通图片
    public var normalImage: UIImage?
    /// 选中图片
    public var selectImage: UIImage?
}

@objc public class TSSegmentedControlConfigItem: NSObject {
    
    /// 底部线的颜色
    public var bottomLineColor: UIColor = 0xf5.ts.color()
    /// 滑动线的宽度
    public var scrollLineWidth: CGFloat = 75.ts.scale()
    /// 滑动线的高度
    public var scrollLineHeight: CGFloat = 3.ts.scale()
    /// 滑动线与底部的距离
    public var scrollLineBottomY: CGFloat = 0
    /// 滑动线与底部的距离
    public var scrollLineColor: UIColor = 0xff5050.ts.color()
    
    /// segmentedControl 文字数组
    public var titles: [TSSegmentedControlTitleItem] = [TSSegmentedControlTitleItem]()
}

public protocol TSSegmentedControlDelegate : class {
    
    /// 选中的位置
    ///
    /// - Parameter index: 选中的下标
    func segmentedControlSelectIndex(index: Int)
    
}

@objc public protocol TSSegmentedControlDataSource {
    
    /// 返回segmentedControl配置
    ///
    /// - Returns: 配置
    @objc optional func segmentedControlSetConfigItem()-> TSSegmentedControlConfigItem!
    
    /// item大小
    ///
    /// - Parameter index: 位置下标
    /// - Returns: size
    @objc optional func segmentedControlItemSize(index: Int) -> CGSize

    /// 间距
    ///
    /// - Parameter index: 位置下标
    /// - Returns: 间距
    @objc optional func segmentedControlItemSpace(index: Int) -> CGFloat
    
    /// 距离左侧间距
    ///
    /// - Returns: 间距
    @objc optional func segmentedControlLeftSpace() -> CGFloat
    
    /// 距离右侧间距
    ///
    /// - Returns: 间距
    @objc optional func segmentedControlRightSpace() -> CGFloat
}

public class TSSegmentedControl: UIView {
    
    /// 选中按钮的回调代理
    public weak var delegate : TSSegmentedControlDelegate?
    /// segmented 配置资源
    public weak var dataSource : TSSegmentedControlDataSource?
    /// segmented 配置
    private var configItem: TSSegmentedControlConfigItem!
    
    private lazy var mainScorllView: UIScrollView = UIScrollView(frame: .zero)
    
    private lazy var mainView: UIView = UIView(frame: .zero)
    
    private lazy var scrollLine: UIView = UIView()
    
    private lazy var bottomLine: UIView = UIView()
    
    private lazy var buttonArray: [UIButton] = [UIButton]()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    
    /// 快捷创建方式（使用该方式创建，可以不使用segmentedControlSetConfigItem这个协议）
    ///
    /// - Parameters:
    ///   - frame: frame
    ///   - titleArray: titles
    ///   - color: 文字选中时的颜色
    ///   - selectColor: 文字选中时的颜色
    ///   - font: 文字大小
    public convenience init(frame: CGRect, titleArray: Array<String>, _ color: UIColor = 0x9.ts.color(), _ selectColor: UIColor = 0xff5050.ts.color(), _ font: UIFont = 15.ts.font(), _ selectFont: UIFont = 15.ts.font()){
        
        self.init(frame: frame)
        
        self.configItem = TSSegmentedControlConfigItem()
        for title in titleArray {
            
            let titleItem = TSSegmentedControlTitleItem()
            titleItem.normalTitle = title
            titleItem.normalColor = color
            titleItem.selectColor = selectColor
            titleItem.normalFont = font
            titleItem.selectFont = selectFont
            self.configItem.titles.append(titleItem)
        }
        self.segmentControlInstall()
    }
    
    /// 配置好configItem后，调用该方法安装segment
    public func segmentControlInstall() {
        
        for subview in self.mainView.subviews {
            subview.removeFromSuperview()
        }
        self.buttonArray.removeAll()
        
        if let data = self.dataSource?.segmentedControlSetConfigItem?() {
            
            self.configItem = data
        }
        createUI()
        createButtons()
        setConstraints()
    }
    
    public override func layoutSubviews() {
        
        super.layoutSubviews()
        self.layoutIfNeeded()
        mainScorllView.contentSize = mainView.frame.size
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//公共函数
extension TSSegmentedControl {
    
    /// 改变选中项
    ///
    /// - Parameter tag: 位置下标
    public func changeSelectButton(index: Int) {
        
        if index < buttonArray.count {
            selectButton(btn: buttonArray[index])
        }else {
            TSLog("TSSegmentedControl: index is not valid")
        }
        
    }
    
    /// 配置默认选中项
    ///
    /// - Parameter tag: 下标
    public func defaultSeletButton(withTag tag: Int) {
        
        guard tag < buttonArray.count else {
            
            TSLog("TSSegmentedControl: default index is not valid")
            return
        }
        
        buttonArray[tag].isSelected = true
        selectButton(btn: buttonArray[tag], animation: false)
    }
}

// MARK: - 私有方法 （创建UI等）
extension TSSegmentedControl {
    
    private func createUI() {
        
        scrollLine.backgroundColor = self.configItem.scrollLineColor
        bottomLine.backgroundColor = self.configItem.bottomLineColor
        addSubview(mainScorllView)
        addSubview(bottomLine)
        mainScorllView.addSubview(mainView)
        mainView.addSubview(scrollLine)
        mainScorllView.showsVerticalScrollIndicator = false
        mainScorllView.showsHorizontalScrollIndicator = false
        if #available(iOS 11.0, *) {
            mainScorllView.contentInsetAdjustmentBehavior = .never
        } else {
            
        }
    }
    
    private func setConstraints() {
        
        mainScorllView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        mainView.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
            make.height.equalToSuperview()
        }
        if self.buttonArray.count > 0 {
            
            scrollLine.snp.makeConstraints { (make) in
                
                make.bottom.equalToSuperview().offset(-self.configItem.scrollLineBottomY)
                make.centerX.equalTo(buttonArray[0])
                make.width.equalTo(self.configItem.scrollLineWidth)
                make.height.equalTo(self.configItem.scrollLineHeight)
            }
        }
        bottomLine.snp.makeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
    
    private func createButtons() {
        
        var tmpButton : UIButton?
        var count: Float = Float(self.configItem.titles.count)
        
        if count > 3 {
            count = 3.0
        }
        var leftSpace: CGFloat = 0
        if let space = self.dataSource?.segmentedControlLeftSpace?() {
            leftSpace = space
        }
        
        var rightSpace: CGFloat = 0
        if let space = self.dataSource?.segmentedControlRightSpace?() {
            rightSpace = space
        }
        for (i, title) in self.configItem.titles.enumerated(){
            
            let button : UIButton = TSSegmentedControlItemButton()
            if let normalTitle = title.normalTitle {
                button.setTitle(normalTitle, for: UIControlState.normal)
            }
            if let selectTitle = title.selectTitle {
                button.setTitle(selectTitle, for: UIControlState.selected)
            }
            if let normalColor = title.normalColor {
                button.setTitleColor(normalColor, for: .normal)
            }
            if let selectColor = title.selectColor {
                button.setTitleColor(selectColor, for: .selected)
            }
            if let normalImage = title.normalImage {
                button.setImage(normalImage, for: UIControlState.normal)
            }
            if let selectImage = title.selectImage {
                button.setImage(selectImage, for: UIControlState.selected)
            }
            button.titleLabel?.font = title.normalFont
            button.adjustsImageWhenHighlighted = false
            button.tag = i
            button.addTarget(self, action: #selector(buttonOnClick(btn:)), for: .touchUpInside)
            mainView.addSubview(button)
            
            var itemSpace: CGFloat = 0
            if let space = self.dataSource?.segmentedControlItemSpace?(index: i) {
                itemSpace = space
            }
            
            button.snp.makeConstraints({ (make) in
                
                if tmpButton != nil{
                    
                    make.left.equalTo(tmpButton!.snp.right).offset(itemSpace)
                    
                }else{
                    
                    make.left.equalToSuperview().offset(leftSpace)
                }
                if let size = self.dataSource?.segmentedControlItemSize?(index: i) {
                    
                    make.centerY.equalToSuperview()
                    make.width.equalTo(size.width)
                    make.height.equalTo(size.height)
                }else {
                    make.top.bottom.equalToSuperview()
                }
            })
            tmpButton = button
            buttonArray.append(button)
        }
        tmpButton?.snp.makeConstraints({ (make) in
            
            make.right.equalToSuperview().offset(rightSpace)
        })
    }
    
    @objc private func buttonOnClick(btn: UIButton){
        
        selectButton(btn: btn)
        
        delegate?.segmentedControlSelectIndex(index: btn.tag)
    }
    
    private func selectButton(btn:UIButton, animation: Bool = true) {
        
        for tempButton in buttonArray {
            
            if tempButton != btn {
                tempButton.isSelected = false
                
                if let font = self.configItem.titles[tempButton.tag].normalFont {
                    tempButton.titleLabel?.font = font
                }
                
            }else{
                btn.isSelected = true
                if let font = self.configItem.titles[tempButton.tag].selectFont {
                    btn.titleLabel?.font = font
                }
            }
        }
        
        scrollLine.snp.remakeConstraints { (make) in
            
            make.bottom.equalToSuperview().offset(-self.configItem.scrollLineBottomY)
            make.centerX.equalTo(btn)
            make.width.equalTo(self.configItem.scrollLineWidth)
            make.height.equalTo(self.configItem.scrollLineHeight)
        }
        
        if animation {
            UIView.animate(withDuration: 0.3) {
                self.layoutIfNeeded()
            }
        }
        
        if ((btn.frame.maxX - self.frame.width) > mainScorllView.contentOffset.x){
            
            mainScorllView.setContentOffset(CGPoint(x: (btn.frame.maxX - self.frame.width), y: 0), animated: true)
        }else if (mainScorllView.contentOffset.x > btn.frame.minX) {
            
            mainScorllView.setContentOffset(CGPoint(x: btn.frame.minX, y: 0), animated: true)
        }
    }
}

/// 为了取消按钮的高亮状态 重写isHighlighted属性
fileprivate class TSSegmentedControlItemButton: UIButton {
    
    override var isHighlighted: Bool {
        set {
            
        }
        get {
            return false
        }
    }
    
}
