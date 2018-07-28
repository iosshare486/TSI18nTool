//
//  TSI18n_Manager.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/25.
//  Copyright © 2018年 洪利. All rights reserved.
//



//内容国际化入口，直接操作者



import UIKit


//外部可直接使用
public let ts_i18n_manager = TSI18n_Manager.createManager()

public class TSI18n_Manager: NSObject {

    var delegater : TSI18nUpdateAppDelegate?
    var activityView = TSI18n_ActivityView.createActivityView()
    
    static var configSinglation : TSI18n_Manager?
    class func createManager() ->TSI18n_Manager {
        if configSinglation == nil {
            let config = TSI18n_Manager()
            return config
        }else{
            return configSinglation!
        }
    }
    public func start(appDelegate:TSI18nUpdateAppDelegate){
        delegater = appDelegate
        //检查本地资源，是否需要更新
        checkWetherUpdate(language: currentLanguage()!) { (contentInfo) in
            if contentInfo != nil {
                //展示遮盖层view
                if self.delegater != nil {
                    self.delegater?.showActivityView(activityView: activityView)
                }
                //开始更新
                ts_i18n_persistence.downloadLanguageSource(url:"https://static.mojieai.com/zh.zip",language: currentLanguage()!) { (state) in
                    //更新结束，回调刷新window
                    self.updateApp()
                    self.activityView.removeFromSuperview()
                }
            }else{
                self.updateApp()
            }
        }
        
        
    }
}

extension TSI18n_Manager{
    func updateApp() {
        //回调
        if delegater != nil {
            delegater?.updateApplication()
        }
    }
}


//读取指定id 内容
extension TSI18n_Manager{
    func getContent(sourceID:String) -> AnyObject? {
        //读取本地资源内容
        if ts_i18n_persistence.cacheContent.count > 0 {
            let content = ts_i18n_persistence.cacheContent[sourceID]
            return content
        }else{
            return nil
        }
    }
    func getImage(sourceID:String) -> AnyObject? {
        //读取本地资源内容
        if (ts_i18n_persistence.cacheContent.count > 0 && ts_i18n_persistence.cacheContent["imagesource"] != nil) {
            //获取本地图片
            let path = (ts_i18n_persistence.cacheContent["imagesource"] as! String) + sourceID + ".png"
            let content = UIImage(contentsOfFile: path)
            return content
        }else{
            return nil
        }
    }
}

//读取本地设置等操作
extension TSI18n_Manager {
    //获取系统当前设置语言
    func currentLanguage() -> String? {
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "language") != nil {
            return defaults.string(forKey: "language")
        }else{
            let languages = defaults.object(forKey: "AppleLanguages")//获取系统支持的所有语言集合
            let preferredLanguage = (languages! as AnyObject).object(at: 0)//集合第一个元素为当前语言
            return String(describing: preferredLanguage)//若当前系统为英文，则返回en_US
        }
    }
    
    
    
    /// 传入需要校验的语言，返回是否需要更新当前语言资源包
    func checkWetherUpdate(language:String, complete: (([String : AnyObject]?)->())){
        //检查本地是否已有
        let source = ts_i18n_persistence.getLanguageCache(language: language)
        if source != nil {
            //有内容
            //检查是否需要更新
            complete(nil)
        }else{
            complete(nil)
        }
        
        
    }
    
    
    func sendWetherUpdateRequest(appVersion:String ,sourceVersion:String,language:String, complete: (([String : AnyObject]?)->())){
        //调用接口查询是否需要更新
        complete(nil)
    }
    
}




//多语言切换
public extension TSI18n_Manager {
    func exchangeLanguage(vc:UIViewController) {
        let rootVC = TSI18n_ExchangeLanguageViewController()
        //构建模型
        let model1 = TSI18nLanguageListModel()
        model1.language = "zh-Hans-US"
        model1.version = "1.1"
        model1.wetherDefault = true
        model1.languageName = "中文(简体)"
        model1.downloadurl = "https://static.mojieai.com/zh-Hans-US.zip"
        let model2 = TSI18nLanguageListModel()
        model2.language = "en"
        model2.version = "1.1"
        model2.wetherDefault = false
        model2.languageName = "English"
        model2.downloadurl = "https://static.mojieai.com/en.zip"
        let model3 = TSI18nLanguageListModel()
        model3.language = "fr"
        model3.version = "1.1"
        model3.wetherDefault = false
        model3.languageName = "France"
        model3.downloadurl = "https://static.mojieai.com/fr.zip"
        rootVC.dataSource = [model1,model2,model3]
        let exVC = UINavigationController(rootViewController: rootVC)
        vc.present(exVC, animated: true, completion: nil)
        
    }
}

