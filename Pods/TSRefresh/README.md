# 下拉刷新使用说明

## 集成方法
<pre>
	let scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: 300,height: 300))
	添加下拉刷新
	scrollView?.ts_addRefreshAction {
            [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        }
   	添加上拉加载 
	scrollView?.ts_addLoadMoreAcion {
            [weak self] in
            print("excute loadMoreBlock")
            self?.loadMore()
        }
   	停止下拉刷新
	scrollView?.ts_endRefreshing(isSuccess: true)
    
    停止上拉加载
	scrollView?.ts_endLoadMore(isNoMoreData: true)
   	是否显示上拉加载
	scrollView?.ts_isShowLoadMore(isShow: false)
</pre>

## 额外配置

<pre>
	// header配置
	scrollView?.ts_pullDownToRefreshText("亲，试试下拉会刷新的") 未到达刷新点提示文案
            .ts_releaseToRefreshText("亲，松开试试") 超过刷新点提示文案
            .ts_refreshSuccessText("亲，成功了")刷新成功文案
            .ts_refreshFailureText("亲，无果")刷新失败文案
            .ts_refreshingText("亲，正在努力刷新")正在刷新文案
        // color
        self.scrollView?.ts_headerTextColor(.red)文字颜色
        // icon
        self.scrollView?.ts_headerIdleImage(UIImage.init(named: "youku_refreshing")) 未到达刷新点展位图片
        self.scrollView?.ts_headerSucImage(UIImage.init(named: "youku_refreshing")) 刷新成功图片
        self.scrollView?.ts_headerFailImage(UIImage.init(named: "youku_refreshing")) 刷新失败图片
        
    //footer配置
    self.scrollView?.ts_footerTextColor(.yellow). 文字颜色
    ts_pullUpToRefreshText("哈哈哈").		未到达刷新点提示文案
    ts_loaddingText("正在刷新").			正在刷新文案
    ts_noMoreDataText("没有数据啦").		无数据展示文字
    ts_releaseLoadMoreText("撒手试试")	超过刷新点提示文案
    
    self.scrollView?.ts_footerIdleImage(UIImage.init(named: "youku_refreshing"))   未到达刷新点展位图片
</pre>

## 自定义下拉刷新和上拉加载

<pre>
	//header配置
	//自定义View，以TSDemoRefreshHeader为例
	class TSDemoRefreshHeader: TSRefreshHeader, TSRefreshHeaderProtocol 	{
		override init(frame: CGRect) {
        
       // let adjustFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frameHeight)
        	super.init(frame: frame)
        	
        }
        override func layoutSubviews() {
        	super.layoutSubviews()
        	
        }
        //必须实现协议 返回控件的高度
        func tsContentHeight()->CGFloat{
        return 60
    	 }
    	 //以下协议为可选实现
    	 /// 正常状态
	    @objc optional func tsToNormalState()
	    /// 刷新状态
	    @objc optional func tsToRefreshingState()
	    /// 下拉状态
	    @objc optional func tsToPullingState()
	    /// 打到最大下拉程度
	    @objc optional func tsToWillRefreshState()
	    /// 下拉高度／触发高度 值改变
	    @objc optional func tsChangePullingPercent(percent: CGFloat)
	    /// 开始回弹动画前执行
	    @objc optional func tsWillBeginEndRefershing(isSuccess: Bool)
	    /// 结束回弹动画完成后执行
	    @objc optional func tsWillCompleteEndRefershing()
	}
	//使用
	let refreshHeader = TSRefreshHeader()
	self.scrollView?.ts_addRefreshHeaderView(refreshHeader: refreshHeader, refreshBlock: { [weak self] in
            print("excute refreshBlock")
            self?.refresh()
        })
	
	//footer配置	
	class TSDemoRefreshFooter: TSLoadMoreFooter, TSLoadMoreProtocol 	{
		override init(frame: CGRect) {
        
       // let adjustFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frameHeight)
        	super.init(frame: frame)
        	
        }
        override func layoutSubviews() {
        	super.layoutSubviews()
        	
        }
        //必须实现协议 返回控件的高度
        func tsContentHeight()->CGFloat{
        return 60
    	 }
    	 //以下协议为可选实现
    	 //默认状态
    	 @objc optional func tsToNormalState()
    	 //没有更多数据状态
    	 @objc optional func tsToNoMoreDataState()
    	 //打到最大上拉程度状态
    	 @objc optional func tsToWillRefreshState()
    	 // 刷新状态
    	 @objc optional func tsToRefreshingState()
	}
	//使用
    let refreshFooter = TSDemoRefreshFooter()
    self.scrollView?.ts_addLoadMoreFooterView(loadMoreFooter: refreshFooter, loadMoreBlock: { [weak self] in
            print("excute refreshBlock")
        })
</pre>
## Pod
pod 'TSRefresh'
