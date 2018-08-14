# TSI18N  国际化通用组件

### 业务流程图
 ![](http://7xoiug.com1.z0.glb.clouddn.com/tsi18n.png)
 
 
### 使用
> 操作对象 ts\_i18n\_manager  
> 启动方法 .start(appDelegate: self)

例：  
AppDelegate.swift中

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ts_i18n_manager.start(appDelegate: self)
        return true
    }
    .
    .
    .
    func applicationDidEnterBackground(_ application: UIApplication) {
        //进入后台
        //暂停任务，保留节点
        ts_i18n_manager.onSuspendMession()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        //由后台进入前台
        //开启断点续传
        ts_i18n_manager.onResumeMession()
	 }
    .
    .
    .
	extension AppDelegate : TSI18nUpdateAppDelegate{
	    func updateApplication() {
	        //在回调函数中进行rootVC的构建
	        window?.rootViewController = ViewController()
	    }
	}

> PS:考虑到应用内切换、以及防止用户看到错误的显示内容，建议在回调函数中进行UI搭建，在此之前会有国际化工具的检查更新页面来填充window


应用内切换语言   

提供2套方案
> 1、利用自带ViewController来展示语言列表
> 2、可以自定义样式实现语言列表页
 
若自定义语言列表样式VC，需要在切换时执行如下代码：

	ts_i18n_persistence.downloadLanguageSource(url:(selectLanguage?.downloadurl)! ,language: (selectLanguage?.language)!) { (state) in
	         //可以根据自身逻辑dismiss或者pop，或者不做处理，下载解压完结后会重新构建window.rootVC逻辑，也就是之前在AppDelegate中实现的协议方法
            self.dismiss(animated: true, completion: nil)
    }

