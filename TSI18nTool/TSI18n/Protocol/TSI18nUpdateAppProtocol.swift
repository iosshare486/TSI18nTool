//
//  TSI18nUpdateAppProtocol.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/25.
//  Copyright © 2018年 洪利. All rights reserved.
//

import Foundation
import UIKit
public protocol TSI18nUpdateAppDelegate {
    //国际化工具回调，通知AppDelegate去设置window.rootVC
    func updateApplication()
}



