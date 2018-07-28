//
//  TSI18n_PersistenceManager.swift
//  TSI18nTool
//
//  Created by 洪利 on 2018/7/25.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit
import SSZipArchive

public let ts_i18n_persistence = TSI18n_PersistenceManager.createManager()
public class TSI18n_PersistenceManager: NSObject {


    var downloadTask: URLSessionDownloadTask?
    var partialData : Data?
    var session : URLSession?
    var request : NSMutableURLRequest?
    var cacheContent = [String : NSObject]()
    var targetLabguage : String?
    var downLoadFinish : ((_ state:Bool)->())?
    
    
    public var lCachePath = "TSI18nCache"
    static var configSinglation : TSI18n_PersistenceManager?
    class func createManager() ->TSI18n_PersistenceManager {
        if configSinglation == nil {
            let config = TSI18n_PersistenceManager()
            return config
        }else{
            return configSinglation!
        }
    }
    //查询本地是否有相应资源，有则返回字典，包含资源版本
    public func getLanguageCache(language:String) -> [String : String]? {
        //获取本地缓存资源
        let filepath = NSHomeDirectory() + "/languageSource/" + language + "/" + language + "/"
        
        let url = URL(fileURLWithPath: filepath + language + ".json")
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:[])
            let jsonDic = json as! Dictionary<String, NSObject>
            cacheContent = jsonDic
            cacheContent["imagesource"] = filepath as NSObject
            //暂时返回空，启动时不会执行下载逻辑
            return nil
        }catch let error as Error{
            return nil
        }
        
        return nil
    }

    public func downloadLanguageSource(url : String,language:String,completed: @escaping (_ state:Bool) -> ()){

       targetLabguage = language
        downLoadFinish = completed
        downloadFile(url: url)
    }
    //挂起下载
    public func onSuspend(sender: AnyObject) {
        if(self.downloadTask != nil)
        {
            //挂起下载任务，将下载好的数据进行保存
            self.downloadTask?.cancel(byProducingResumeData: { (resumeData) in
                self.partialData = resumeData
                self.downloadTask = nil
            })
        }
        //        downloadTask!.suspend()
    }
    //恢复下载
    public func onResume(sender: AnyObject) {
        if(downloadTask == nil)
        {
            URLSession.shared
            //判断是否又已下载数据，有的话就断点续传，没有就完全重新下载
            if(self.partialData != nil)
            {
                self.downloadTask = self.session?.downloadTask(withResumeData: self.partialData! as Data)
            }
            else{
                self.downloadTask = self.session?.downloadTask(with: self.request! as URLRequest)
            }
        }
        downloadTask!.resume()
    }
    //开始下载文件
    public func downloadFile(url:String)
    {
        NSLog("正在下载")
        //创建URL
        /**
         https://static.mojieai.com/zh.zip
         https://static.mojieai.com/fr.zip
         https://static.mojieai.com/en.zip
         */
        var urlStr:NSString = NSString(string: url)
        urlStr = urlStr.removingPercentEncoding! as NSString
        let url = NSURL(string: urlStr as String)!
        //创建请求
        request = NSMutableURLRequest(url: url as URL)
        //创建默认会话
        let sessionConfig : URLSessionConfiguration = URLSessionConfiguration.default
        sessionConfig.timeoutIntervalForRequest = 20 //设置请求超时时间
        sessionConfig.allowsCellularAccess = true //是否允许蜂窝网络下载
        //创建会话
        session = URLSession(configuration: sessionConfig, delegate: self, delegateQueue: nil)//指定配置和代理
        downloadTask = session!.downloadTask(with: request! as URLRequest)
        downloadTask!.resume()
    }
    
    
    //设置页面状态
    func setUIStatus(totalBytesWritten : Int64,expectedToWrite totalBytesExpectedToWrite:Int64 )
    {
        //调用主线程刷新UI
        
        DispatchQueue.main.async {
            if(Int(totalBytesExpectedToWrite) != 0 && Int(totalBytesWritten) != 0)
            {
                //更新进度条
                let progress = Float(Float(totalBytesWritten) / Float(totalBytesExpectedToWrite))
                if(totalBytesExpectedToWrite == totalBytesWritten)
                {
//                    self.lbl_hint.text! = "下载完毕"
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = false
//                    self.btn_download.enabled = true
                }
                else{
//                    self.lbl_hint.text = "正在下载"
//                    UIApplication.sharedApplication().networkActivityIndicatorVisible = true
                }
            }
        }
    }
}



extension TSI18n_PersistenceManager : URLSessionDownloadDelegate{
    //下载代理方法，下载结束
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {
        //下载结束
        print("下载结束")
        
//        输出下载文件原来的存放目录
//        print("location:\(location)")
        //location位置转换
        let locationPath = location.path
        //拷贝到用户目录
        let documnets:String = NSHomeDirectory() + "/Documents/" + targetLabguage! + ".zip"
        //创建文件管理器
        let fileManager = FileManager.default
        let resultOfZip = fileManager.fileExists(atPath: documnets)
        if resultOfZip == true {
            try! fileManager.removeItem(atPath: documnets)
        }
        try! fileManager.moveItem(atPath: locationPath, toPath: documnets)
        print("new location:\(documnets)")
        
        // 创建文件夹
        let newFilepath = NSHomeDirectory() + "/languageSource/" + targetLabguage!
        let resultOfNewFile = fileManager.fileExists(atPath: newFilepath)
        if resultOfNewFile == true {
            try! fileManager.removeItem(atPath: newFilepath)
        }
        try! fileManager.createDirectory(at: URL(fileURLWithPath: newFilepath), withIntermediateDirectories: true, attributes: nil)
        // 解压缩zip文件
        SSZipArchive.unzipFile(atPath: documnets, toDestination: newFilepath, delegate: self)
    }
    
    //下载代理方法，监听下载进度
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64, totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {
        //获取进度
        let written:CGFloat = (CGFloat)(totalBytesWritten)
        let total:CGFloat = (CGFloat)(totalBytesExpectedToWrite)
        let pro:CGFloat = written/total
        print("下载进度：\(pro)")
    }
    
    //下载代理方法，下载偏移
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                    didResumeAtOffset fileOffset: Int64, expectedTotalBytes: Int64) {
        //下载偏移，主要用于暂停续传
    }
    
    
}



extension TSI18n_PersistenceManager : SSZipArchiveDelegate{
    public func zipArchiveWillUnzipArchive(atPath path: String, zipInfo: unz_global_info) {
        print("开始解压")
    }
    public func zipArchiveDidUnzipArchive(atPath path: String, zipInfo: unz_global_info, unzippedPath: String) {
        //设置本地缓存
        let targetSourcePath = unzippedPath + "/" + targetLabguage! + "/" + targetLabguage! + ".json"
        
        let url = URL(fileURLWithPath: targetSourcePath)
        do{
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options:[])
            let jsonDic = json as! Dictionary<String, NSObject>
            cacheContent = jsonDic
            cacheContent["imagesource"] = unzippedPath + "/" + targetLabguage! + "/" as NSObject
            //回调主线程
            DispatchQueue.main.async {
                if self.downLoadFinish != nil {
                    self.downLoadFinish!(true)
                }
                
                //更新UI
                ts_i18n_manager.updateApp()
            }
            
            
        }catch let error as Error{
            
        }
        
//        self.setUIStatus(totalBytesWritten: <#T##Int64#>, expectedToWrite: <#T##Int64#>)
    }
}


