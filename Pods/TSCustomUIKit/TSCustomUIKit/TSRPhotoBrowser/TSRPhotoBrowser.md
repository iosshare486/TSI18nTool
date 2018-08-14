# TSRPhotoBrowser

```
图片资源浏览 (支持长图)
```

## Usage

<pre> 
// 初始化
 let browserView = TSRPhotoBrowserView()

// 设置数据源 (URL或UIImage类型可选设置)
 browserView.originUrls = [".png",".png"] //源图片地址
 browserView.thumbnailUrls = [".png",".png"] //缩略图地址（可选设置）
 browserView.locationImages = [image,image] //本地Image

// 弹出视图
 browserView.show()

// 设置选择图片位置 (默认 0)
 browserView.selectIndex = 1
 
// 设置视图开启与关闭匹配图片原位置动画 --(可选设置)
 browserView.originRect = [CGRect, CGRect]

// 设置支持图片长按操作
 browserView.delegate = self
 实现协议方法
 func longPressGestureRecognizerEvent(img: UIImage) {
  // 在此添加长按手势触发内容
  // img 为长按手势所选中图片
 }
</pre>

## For Objective-C
<pre>
在Class顶部引入 #import "xxxx-Swift.h" 即可
</pre>