//
//  TSKeyBoardToolBar.swift
//  TSCustomUIKit
//
//  Created by huangyuchen on 2018/7/17.
//  Copyright © 2018年 caiqr. All rights reserved.
//  封装键盘弹出收起的动画 直接赋值subItem即可

import UIKit
import SnapKit

public class TSKeyBoardToolBar: UIView {

    public var keyboardShowOrHide: ((_ isShow: Bool)->Void)?
    
    public var subItem: UIView! {
        
        didSet {
            
            inputBaseView.addSubview(subItem)
            subItem.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private var inputBaseView: UIView = UIView()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(inputBaseView)
        inputBaseView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(0)
            make.left.right.equalToSuperview()
        }
        
        //添加键盘弹出监听
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoradWillChangeFrame(notification:)), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc private func keyBoradWillChangeFrame(notification: Notification) {
        
        if let userInfo = notification.userInfo,
            let value = userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey] as? Double,
            let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? UInt {
            let frame = value.cgRectValue
            
            self.inputBaseView.snp.updateConstraints { (make) in
                make.bottom.equalToSuperview().offset(frame.origin.y - UIScreen.main.bounds.height)
            }
            
            UIView.animate(withDuration: duration, delay: 0, options: UIViewAnimationOptions(rawValue: curve), animations: {
                self.superview?.layoutIfNeeded()
            }, completion: nil)
        }
    }
    
    @objc private func keyBoardWillShow() {
        
        
        self.keyboardShowOrHide?(true)
    }
    
    @objc private func keyBoardWillHide() {
        
        self.keyboardShowOrHide?(false)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
