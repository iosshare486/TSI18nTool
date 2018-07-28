//
//  TSI18nExtension.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/25.
//  Copyright © 2018年 洪利. All rights reserved.
//

import Foundation
import UIKit


private var tsI18n_id_view: String?
extension UIView {
    @IBInspectable var tsI18n_id: String? {
        get {
            return objc_getAssociatedObject(self, &tsI18n_id_view) as? String
        }
        set(newValue) {
            objc_setAssociatedObject(self, &tsI18n_id_view, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

extension UILabel {
    func set_i18n_text() {
        if (self.tsI18n_id != nil && (self.tsI18n_id?.count)! > 0) {
            let text = ts_i18n_manager.getContent(sourceID: self.tsI18n_id!)
            if (text != nil && ((text as! String).count)>0) {
                self.text = text as? String
            }
        }
    }
}

extension UIButton {
    
    func set_i18n_title(state:UIControlState) {
        if (self.tsI18n_id != nil && (self.tsI18n_id?.count)! > 0) {
            let text = ts_i18n_manager.getContent(sourceID: self.tsI18n_id!) as! String
            if (text != nil && text.count>0) {
                self.setTitle(text, for: state)
            }
        }
    }
    func set_i18n_image(state:UIControlState) {
        if (self.tsI18n_id != nil && (self.tsI18n_id?.count)! > 0) {
            let image = ts_i18n_manager.getContent(sourceID: self.tsI18n_id!) as! UIImage
            if (image != nil) {
                self.setImage(image, for: state)
            }
        }
    }
    func set_i18n_back_image(state:UIControlState) {
        if (self.tsI18n_id != nil && (self.tsI18n_id?.count)! > 0) {
            let image = ts_i18n_manager.getContent(sourceID: self.tsI18n_id!) as! UIImage
            if (image != nil) {
                self.setBackgroundImage(image, for: state)
            }
        }
    }
}


extension UIImageView {
    
    func set_i18n_image() {
        if (self.tsI18n_id != nil && (self.tsI18n_id?.count)! > 0) {
            let image = ts_i18n_manager.getImage(sourceID: self.tsI18n_id!)
            if (image != nil) {
                self.image = image as? UIImage
            }
        }
    }
}








