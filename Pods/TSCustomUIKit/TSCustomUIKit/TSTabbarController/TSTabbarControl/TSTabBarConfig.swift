//
//  TSTabBarConfig.swift
//  TSTabbarController
//
//  Created by 洪利 on 2018/7/7.
//  Copyright © 2018年 洪利. All rights reserved.
//

import UIKit

protocol TSTabbarDefaultConfig {
    func tabBarDefaultConfig() -> ()
}
public enum TSConfigTypeLayout:Int,Codable {
    case TSConfigTypeLayoutNormal = 0 //默认布局 图片在上 文字在下
    case TSConfigTypeLayoutImage = 1 //只有图片 (图片居中)
}
public enum TSConfigTabBarAnimType:Int,Codable {
    case TSConfigTabBarAnimTypeNormal = 0 //无动画
    case TSConfigTabBarAnimTypeRotationY = 1 //Y轴旋转
    case TSConfigTabBarAnimTypeBoundsMin = 2 //缩小
    case TSConfigTabBarAnimTypeBoundsMax = 3 //放大
    case TSConfigTabBarAnimTypeScale = 4 //缩放动画
}

public enum TSConfigBadgeAnimType:Int,Codable {
    case TSConfigBadgeAnimTypeNormal = 0 //无动画
    case TSConfigBadgeAnimTypeShake = 1 //抖动动画
    case TSConfigBadgeAnimTypeOpacity = 2 //透明过渡动画
    case TSConfigBadgeAnimTypeScale = 3 //缩放动画
}

public typealias TSConfigCustomBtnBlock = (()->(btn:UIButton, index:NSInteger))

public let ts_tabbar_config = TSTabBarConfig.createConfig()







open class TSTabBarConfig: NSObject {
    
    /******************************** tabBar 基本配置 ********************************/
    /** 布局类型 (默认是 图片在上, 文字在下) */
    private(set) var typeLayout : TSConfigTypeLayout = .TSConfigTypeLayoutNormal
    /** 标题的默认颜色 (默认为 #808080) */
    private(set) var norTitleColor : UIColor = UIColor.ts_colorWithHexString(color: "#808080")
    /** 标题的选中颜色 (默认为 #d81e06)*/
    private(set) var selTitleColor : UIColor = UIColor.ts_colorWithHexString(color: "#d81e06")
    /** 图片的size (默认 28*28) */
    private(set) var imageSize : CGSize = CGSize(width: 28, height: 28)
    private(set) var tabBarAnimtype : TSConfigTabBarAnimType?
    /** 是否显示tabBar顶部线条颜色 (默认 YES) */
    var isClearTabBarTopLine : Bool = true
    /** tabBar顶部线条颜色 (默认亮灰色) */
    private(set) var tabBarTopLineColor : UIColor = .lightGray
    /** tabBar的背景颜色 (默认白色) */
    private(set) var tabBarBackground : UIColor = .white
    /** tabBarController */
    var tabBarController : TSTabbarViewController?
    private(set) var controllersArr : Array<UIViewController> = []
    private(set) var titleArr : Array<String> = []
    private(set) var norImageArr : Array<UIImage> = []
    private(set) var selImageArr : Array<UIImage> = []
    
    
    public func setTypeLayout(typeLayout: TSConfigTypeLayout) {
        self.typeLayout = typeLayout
    }
    public func setNorTitleColor(color: UIColor) {
        self.norTitleColor = color
    }
    public func setSelTitleColor(color: UIColor) {
        self.selTitleColor = color
    }
    public func setImageSize(imageSize: CGSize) {
        self.imageSize = imageSize
    }
    public func setTabBarAnimtype(type:TSConfigTabBarAnimType) {
        self.tabBarAnimtype = type
    }
    public func setIsClearTabBarTopLine(state:Bool) {
        self.isClearTabBarTopLine = state
    }
    public func setTabBarBackground(color:UIColor) {
        self.tabBarBackground = color
    }
    public func setTabBarTopLineColor(color:UIColor) {
        self.tabBarTopLineColor = color
    }
    public func setControllersArr(controllers: [UIViewController]) {
        self.controllersArr = controllers
    }
    public func setTitleArr(array: [String]) {
        self.titleArr = array
    }
    public func setNorImageArr(normalimagearr: [UIImage]) {
        self.norImageArr = normalimagearr
    }
    public func setSelImageArr(selimagearr: [UIImage]) {
        self.selImageArr = selimagearr
    }
    public func setBadgeTextColor(color: UIColor) {
        self.badgeTextColor = color
    }
    
    public func setBadgeBackgroundColor(color: UIColor) {
        self.badgeBackgroundColor = color
    }
    public func setBadgeSize(size: CGSize) {
        self.badgeSize = size
    }
    public func setBadgeOffset(offset: CGPoint) {
        self.badgeOffset = offset
    }
    public func setBadgeRadius(radius: CGFloat) {
        self.badgeRadius = radius
    }
    public func setbadgeAnimType(type: TSConfigBadgeAnimType) {
        self.animType = type
    }
    public func setTabBarInfo(info: [TSTabBarInfoModel]) {
        self.tabBarInfo = info
    }
    
    /***********************************************************************************/
    
    private(set) var tabBarInfo : [TSTabBarInfoModel] = []{
        didSet{
            for tabBarItem in tabBarInfo {
                self.titleArr.append(tabBarItem.title)
                self.norImageArr.append(tabBarItem.norImage!)
                self.selImageArr.append(tabBarItem.selImage!)
                self.controllersArr.append(tabBarItem.controller!)
            }
        }
    }
    
    /******************************** badgeValue 基本配置 ********************************/
    /** badgeColor(默认 #FFFFFF) */
    private(set) var badgeTextColor : UIColor = .white{
        didSet{
            let arrM = getTabBarButtons()
            for btn in arrM {
                btn.badgeValue?.badgeL.textColor = self.badgeTextColor
            }
        }
    }
    /** badgeBackgroundColor (默认 #FF4040)*/
    private(set) var badgeBackgroundColor : UIColor = UIColor.ts_colorWithHexString(color: "#FF4040"){
        didSet{
            let arrM = getTabBarButtons()
            for btn in arrM {
                btn.badgeValue?.badgeL.backgroundColor = self.badgeBackgroundColor;
            }
        }
    }
    /** badgeSize (如没有特殊需求, 请勿修改此属性, 此属性只有在控制器加载完成后有效)*/
    private(set) var badgeSize: CGSize = CGSize(width: 20.0, height: 20.0) {
        didSet{
            let arrM = getTabBarButtons()
            for btn in arrM {
                btn.badgeValue?.badgeL.ts_size = self.badgeSize
            }
        }
    }
    /** badgeOffset (如没有特殊需求, 请勿修改此属性, 此属性只有在控制器加载完成后有效) */
    private(set) var badgeOffset : CGPoint = CGPoint(x: 0, y: 0 ){
        didSet{
            let arrM = getTabBarButtons()
            for btn in arrM {
                btn.badgeValue?.badgeL.ts_x += self.badgeOffset.x
                btn.badgeValue?.badgeL.ts_y += self.badgeOffset.y
            }
        }
    }
    /** badge圆角大小 (如没有特殊需求, 请勿修改此属性, 此属性只有在控制器加载完成后有效, 一般配合badgeSize或badgeOffset使用) */
    private(set) var badgeRadius : CGFloat = 4.0{
        didSet{
            let arrM = getTabBarButtons()
            for btn in arrM {
                btn.badgeValue?.badgeL.layer.cornerRadius = self.badgeRadius
            }
        }
    }
    /** badge动画 (默认无动画) */
    private(set) var animType : TSConfigBadgeAnimType?
    
    
    
    /******************************** 自定义按钮 基本配置 ********************************/
    /** btnClickBlock */
    public var btnClickBlock : TSConfigCustomBtnBlock?
    
    static var configSinglation : TSTabBarConfig?
    class func createConfig() ->TSTabBarConfig {
        if configSinglation == nil {
            let config = TSTabBarConfig()
            config.configNormal()
            return config
        }else{
            return configSinglation!
        }
    }
    
    func configNormal() {
        self.norTitleColor = UIColor.ts_colorWithHexString(color: "#808080")
        self.selTitleColor = UIColor.ts_colorWithHexString(color: "#d81e06")
        self.isClearTabBarTopLine = true;
        self.tabBarTopLineColor = .lightGray
        self.tabBarBackground = .white
        self.typeLayout = .TSConfigTypeLayoutNormal
        self.imageSize = CGSize(width:28, height:28)
        self.badgeTextColor = UIColor.ts_colorWithHexString(color:"#FFFFFF")
        self.badgeBackgroundColor = UIColor.ts_colorWithHexString(color:"#FF4040")
    }
    
    /**
     对单个进行圆角设置
     @param radius 圆角值
     @param index 下标
     */
    public func badgeRadius(radius:CGFloat, index:NSInteger) {
        let tabBarButton = self.getTabBarButtonAtIndex(index:index)
        tabBarButton.badgeValue?.badgeL.layer.cornerRadius = radius;
    }
    
    /**
     显示圆点badgevalue  (以下关于badgeValue的操作可以在app全局操作)  使用方法 [[JMConfig config] showPointBadgeValue: AtIndex: ]
     @param index 显示的下标
     */
    public func showPointBadgeAtIndex(index:NSInteger) {
        let tabBarButton = self.getTabBarButtonAtIndex(index:index)
        tabBarButton.badgeValue?.isHidden = false;
        tabBarButton.badgeValue?.type = TSBadgeValueType.TSBadgeValueTypePoint;
    }
    
    
    /**
     显示newBadgeValue (以下关于badgeValue的操作可以在app全局操作)
     @param index 下标
     */
    public func showNewBadgeAtIndex(index:NSInteger) {
        let tabBarButton = self.getTabBarButtonAtIndex(index:index)
        tabBarButton.badgeValue?.isHidden = false;
        tabBarButton.badgeValue?.badgeL.text = "new";
        tabBarButton.badgeValue?.type = TSBadgeValueType.TSBadgeValueTypeNew;
        
    }
    
    /**
     显示带数值的下标  (注意: 此方法可以全局重复调用)
     @param badgeValue 数值
     @param index 下标
     */
    public func showNumberBadgeValue(badgeValue:String, index:NSInteger) {
        let tabBarButton = self.getTabBarButtonAtIndex(index:index)
        tabBarButton.badgeValue?.isHidden = false;
        tabBarButton.badgeValue?.badgeL.text = badgeValue;
        tabBarButton.badgeValue?.type = TSBadgeValueType.TSBadgeValueTypeNumber;
    }
    
    
    /**
     隐藏下标的badgeValue
     
     @param index 下标
     */
    public func hideBadgeAtIndex(index:NSInteger) {
        self.getTabBarButtonAtIndex(index:index).badgeValue?.isHidden = true
    }
    
    
    /******************************** 自定义按钮 基本配置 ********************************/
    
    
    /**
     添加自定义按钮 (目前只支持自定义按钮, 如果需要自定义view或者对加号按钮有更多需求的请联系我)
     @param btn 自定义btn
     @param index 添加的下标位置
     @param btnClickBlock 按钮点击事件的回调
     */
    
    public func addCustomBtn(btn:UIButton, index:NSInteger , btnClickBlock:@escaping TSConfigCustomBtnBlock) {
        btn.tag = index;
        btn.addTarget(self, action: #selector(customBtnClick), for:.touchUpInside)
        self.btnClickBlock = btnClickBlock;
        self.tabBarController?.ts_tabBar.addSubview(btn);
        
    }
    
    @objc func customBtnClick(sender:UIButton) {
        
    }
    
    
    
    func getTabBarButtonAtIndex(index:NSInteger) -> TSTabbarButton {
        let subViews = self.tabBarController?.ts_tabBar.subviews;
        for btn in subViews! {
            if btn.isKind(of: TSTabbarButton.self) && subViews?.index(of: btn) == index{
                return btn as! TSTabbarButton
            }
        }
        let sBtn : TSTabbarButton? = nil
        return sBtn!
    }
    
    func getTabBarButtons() ->Array<TSTabbarButton> {
        let subViews = self.tabBarController?.ts_tabBar.subviews
        var tempArr = Array<TSTabbarButton>()
        if subViews != nil {
            for btn in subViews! {
                if btn.isKind(of:TSTabbarButton.self) {
                    tempArr.append(btn as! TSTabbarButton)
                }
            }
        }
        return tempArr;
    }
    
}





public extension TSTabBarConfig{
    public func getTabBarVC() -> TSTabbarViewController {
        self.tabBarController = TSTabbarViewController().initWithTabBarControllers()
        return self.tabBarController!
        
    }
    
}








open class TSTabBarInfoModel: NSObject {
    open var title : String = ""
    open var norImage : UIImage?
    open var selImage : UIImage?
    open var controller : UIViewController?
    
}






