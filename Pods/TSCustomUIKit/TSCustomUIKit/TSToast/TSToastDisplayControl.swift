//
//  TSToastDisplayControl.swift
//  TSToastView
//
//  Created by 洪利 on 2018/6/28.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SnapKit
import TSUtility

public let TSToastControl = TSToastDisplayControl.sharedInstance()

public enum TSToastAnimationStyle : Int{
    case fade                 //渐隐渐显
    case upAndDown            //上出下走
    case upDownAndFade  //上下+渐隐
}

public enum TSToastShowStyle : Int {
    case oneByOne   //一个接一个的展示
    case cover      //直接替换当前显示文案
}


open class TSToastDisplayControl: NSObject {

    //动画形式
    public var animationStyle = TSToastAnimationStyle.fade
    
    //toastView 圆角弧度
    public var tostViewCornerRadius: CGFloat = 4.0 {
        didSet {
            toastView.layer.cornerRadius = CGFloat(tostViewCornerRadius)
        }
    }
    
    //toastView 圆角弧度
    public var toastBackgroundColor = UIColor.black {
        didSet {
            toastView.backgroundColor = toastBackgroundColor
        }
    }
    
    private var toastView = UILabel()
    
    class func sharedInstance() -> TSToastDisplayControl {
        let tsToastControl = TSToastDisplayControl()
        tsToastControl.configToastView()
        return tsToastControl
    }
    
    
    func configToastView() {
        toastView.alpha = 0
        toastView.font = 14.ts.font()
        toastView.backgroundColor = "#000000".ts.color(0.6)
        toastView.textAlignment = .center
        toastView.layer.masksToBounds = true
        toastView.layer.cornerRadius = tostViewCornerRadius 
        toastView.textColor = .white
    }
    
    /// 默认展示到window上
    ///
    /// - Parameter content: toast 文案
    public func showToast( _ content: String?)  {
        
        guard let toastText = content, toastText.count > 0 else {
            return
        }
        
        toastView.text = content
        toastView.layer.cornerRadius = CGFloat(tostViewCornerRadius)
        
        if toastView.superview == nil {
            let window = UIApplication.shared.keyWindow
            if window == nil {
                return
            }
            window?.addSubview(toastView)
        }
        toastView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(38.ts.scale())
            make.centerY.equalToSuperview()
            make.width.equalTo(self.getTextWidth(text: toastText))
        }
        needShowToast()
    }
    
    func getTextWidth(text: String) -> CGFloat {
        
        let attributedStr: NSMutableAttributedString = NSMutableAttributedString.init(string: text)
        
        attributedStr.setAttributes([NSAttributedStringKey.font : 14.ts.font()], range: NSMakeRange(0, attributedStr.length))

        TSLog(attributedStr.size())
        
        return attributedStr.size().width + 56.ts.scale()
    }
    
    /// 指定父视图展示toast
    ///
    /// - Parameters:
    ///   - onSpecificView: 父视图
    ///   - content: toast 文案
    public func showToast(onSpecificView: UIView, content: String)  {
        if onSpecificView == nil {
            return
        }
        if content.count == 0 {
            return
        }
        toastView.text = " " + content + " "
        toastView.layer.cornerRadius = CGFloat(tostViewCornerRadius)
        if toastView.superview != nil {
            toastView.removeFromSuperview()
        }
        onSpecificView.addSubview(toastView)
        toastView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(30*UIScreen.main.bounds.size.width / 375.0)
            make.centerY.equalToSuperview().multipliedBy(1.7)
        }
        needShowToast()
    }
    
    
    
    func needShowToast()  {
        switch animationStyle {
        case .fade: do{
            startAnimationWithFadeStyle()
        };break;
        case .upAndDown: do{
            startAnimationWithUpAndDownStyle()
        };break;
        case .upDownAndFade: do{
            startAnimationWithUpDownAndFadeStyle()
        };break;
        }
    }
    
    
    /// 单纯的渐隐渐显动画
    func startAnimationWithFadeStyle(){
    
        UIView.animate(withDuration: 0.3, animations: {
            self.toastView.alpha = 1
        }) { (status) in
        
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
                self.toastView.alpha = 0
            }, completion: { (status) in
                self.toastView.removeFromSuperview()
            })
        }
    }
    //上下弹出动画
    func startAnimationWithUpAndDownStyle(){
        //修改位置
        toastView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(38.ts.scale())
            make.top.equalTo((toastView.superview?.snp.bottom)!)
        }
        toastView.superview?.layoutIfNeeded()
        self.toastView.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.toastView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(38.ts.scale())
                make.centerY.equalToSuperview()
            }
            self.toastView.superview?.layoutIfNeeded()
        }) { (status) in
            
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
                
                self.toastView.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.height.equalTo(38.ts.scale())
                    make.top.equalTo((self.toastView.superview?.snp.bottom)!)
                }
                self.toastView.superview?.layoutIfNeeded()
            }, completion: { (status) in
                self.toastView.alpha = 0
                self.toastView.removeFromSuperview()
            })
        }
    }
    
   
    /// 上下弹出 + 渐隐渐显
    func startAnimationWithUpDownAndFadeStyle(){
        //修改位置
        self.toastView.alpha = 0
        toastView.snp.remakeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(38.ts.scale())
            make.top.equalTo((toastView.superview?.snp.bottom)!)
        }
        toastView.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, animations: {
            self.toastView.snp.remakeConstraints { (make) in
                make.centerX.equalToSuperview()
                make.height.equalTo(38.ts.scale())
                make.centerY.equalToSuperview()
            }
            self.toastView.superview?.layoutIfNeeded()
            self.toastView.alpha = 1
        }) { (status) in
            
            UIView.animate(withDuration: 0.3, delay: 1.5, options: .curveLinear, animations: {
                
                self.toastView.snp.remakeConstraints { (make) in
                    make.centerX.equalToSuperview()
                    make.height.equalTo(20*UIScreen.main.bounds.size.width / 375.0)
                    make.top.equalTo((self.toastView.superview?.snp.bottom)!)
                }
                self.toastView.superview?.layoutIfNeeded()
                self.toastView.alpha = 0
            }, completion: { (status) in
                self.toastView.removeFromSuperview()
            })
        }
    }
    
}


public extension UIView {
    
    public func ts_toast(content:String) {
        TSToastControl.showToast(onSpecificView: self, content: content)
    }
    public func ts_toast(content:String, animation:TSToastAnimationStyle?, backgroundColor:UIColor?,cornerRadius:CGFloat?) {
        if content.count > 0 {
            if animation != nil {
                TSToastControl.animationStyle = animation!
            }
            if backgroundColor != nil {
                TSToastControl.toastBackgroundColor = backgroundColor!
            }
            if (cornerRadius! > 0 && cornerRadius != nil) {
                TSToastControl.tostViewCornerRadius = cornerRadius!
            }
            TSToastControl.showToast(onSpecificView: self, content: content)
        }
    }
    
    
    
}


