//
//  TSRPhotoBrowserCollectionViewCell.swift
//  TSSocialTest
//
//  Created by 彩球 on 2018/7/1.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit
import Kingfisher



protocol TSRPhotoBrowserCollectionViewCellDelegate {
    
    func backgroundAlpha(alpha: CGFloat)
    func hiddenAction(cell: TSRPhotoBrowserCollectionViewCell)
}

class TSRPhotoBrowserCollectionViewCell: UICollectionViewCell {
    
    let ImageW = UIScreen.main.bounds.size.width - 10
    
    fileprivate lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.delegate = self
        sv.backgroundColor = .clear
        sv.maximumZoomScale = 2
        sv.minimumZoomScale = 1
        return sv
    }()
    
    lazy var imageV: UIImageView = {
        let v = UIImageView()
        self.scrollView.addSubview(v)
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.isUserInteractionEnabled = true
        return v
    }()
    
    var delegate: TSRPhotoBrowserCollectionViewCellDelegate?
    
    var longPressEvent: ((UIImage) -> Void)?
    
    var listCellF: CGRect?
    var isFirstLoad: Bool = false
    
    fileprivate var imgOriginF: CGRect? //在中心时候的坐标
    fileprivate var imgOriginCenter: CGPoint?
    fileprivate var moveImgFirstPoint: CGPoint? //记录第一次移动图片位置
    
    fileprivate var firstTouchPoint: CGPoint? // 记录刚触碰第一次时候的点
    
    fileprivate var panGes: UIPanGestureRecognizer!
    fileprivate var tapSingle: UITapGestureRecognizer!
    fileprivate var tapDouble: UITapGestureRecognizer!
    
    // 控制时间
    var panStartTime: Date?
    var panEndTime: Date?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(scrollView)
        initGesture()
        
        
    }
    
    
    private func initGesture() {
        panGes = UIPanGestureRecognizer(target: self, action: #selector(imageViewPressAction(ges:)))
        panGes.delegate = self
        scrollView.addGestureRecognizer(panGes)
        
        tapSingle = UITapGestureRecognizer(target: self, action: #selector(imageViewSingleTapAction(ges:)))
        tapSingle.delegate = self
        tapSingle.numberOfTapsRequired = 1
        scrollView.addGestureRecognizer(tapSingle)
        
        tapDouble = UITapGestureRecognizer(target: self, action: #selector(imageViewDoubleTapAction(ges:)))
        tapDouble.numberOfTapsRequired = 2
        tapSingle.require(toFail: tapDouble)
        scrollView.addGestureRecognizer(tapDouble)
        
        let long = UILongPressGestureRecognizer(target: self, action: #selector(imageViewLongPressAction(ges:)))
        imageV.addGestureRecognizer(long)
    }
    
    func setPicImage(_ img: UIImage) {
        imageV.image = img
        updateImageView(img: img)
    }
    
    
    func setPicURL(originURLStr: String, thumbnailURLStr: String?) {
        if thumbnailURLStr != nil, thumbnailURLStr!.count > 0 {
            if let url = URL(string: thumbnailURLStr!) {
                let imgResource = ImageResource(downloadURL: url)
                KingfisherManager.shared.retrieveImage(with: imgResource, options: nil, progressBlock: nil) { (img, err, cache, ur) in
                    self.updateImageView(img: img)
                }
            }
        }
        
        if let url = URL(string: originURLStr) {
            let imgResource = ImageResource(downloadURL: url)
            imageV.kf.setImage(with: imgResource, placeholder: nil, options: nil, progressBlock: nil) { (img, err, cache, ur) in
                self.updateImageView(img: img)
            }
        }
        
    }
    
    private func updateImageView(img: UIImage?) {
        if img == nil {
            return
        }
        imgOriginF = nil
        imgOriginCenter = nil
        moveImgFirstPoint = nil
        firstTouchPoint = nil
        scrollView.zoomScale = 1
        
        
        imageV.image = img
        var imageView_Y: CGFloat = 0.0
        let imageWidth: CGFloat = img!.size.width
        let imageHeight: CGFloat = img!.size.height
        
        
        let fitWidth: CGFloat = ImageW
        let fitHeight: CGFloat = fitWidth * imageHeight / imageWidth
        
        if fitHeight < UIScreen.main.bounds.size.height {
            imageView_Y = (UIScreen.main.bounds.size.height - fitHeight) * 0.5
        }
        
        imgOriginF = CGRect(x: 5.0, y: imageView_Y, width: fitWidth, height: fitHeight)
        
        
        if isFirstLoad && listCellF != nil {
            isFirstLoad = false
            imageV.frame = listCellF!
            UIView.animate(withDuration: 0.3) {
                self.imageV.frame = self.imgOriginF!
                self.imgOriginCenter = self.imageV.center
                self.delegate?.backgroundAlpha(alpha: 1)
            }
            
        } else {
            imageV.frame = imgOriginF!
            imgOriginCenter = imageV.center
        }
        
        scrollView.contentSize = CGSize(width: fitWidth, height: fitHeight)
        
    }
    
    
    /// 隐藏
    private func hiddenAction() {
        
        self.delegate?.hiddenAction(cell: self)
    }
    
    /// 拖拽
    @objc func imageViewPressAction(ges: UIPanGestureRecognizer) {
        
        let movePoint = ges.location(in: self.window)
        switch ges.state {
        case .began:
            panStartTime = Date()
            moveImgFirstPoint = ges.location(in: self.window)
            break
        case .changed:
            
            let v = movePoint.y / UIScreen.main.bounds.size.height
            let tmpNum = 1.0 - ((v > moveImgFirstPoint!.y / UIScreen.main.bounds.size.height) ? v : (1.0 - v))
            let offset = fmin(tmpNum * 2.0, 1)
            let offset_y = fmax(offset, 0.5)
            let transhform1 = CGAffineTransform(translationX: movePoint.x - moveImgFirstPoint!.x, y: movePoint.y - moveImgFirstPoint!.y)
            
            let kScreenH = UIScreen.main.bounds.size.height
            let m = offset_y * (1 + (log10(imgOriginF!.size.height) / log10(kScreenH) * 0.713))
            let scaleV = imgOriginF!.size.height > kScreenH ? (m > 1 ? 1 : m) : offset_y
            self.imageV.transform = CGAffineTransform(scaleX: scaleV, y: scaleV).concatenating(transhform1)
            
            self.delegate?.backgroundAlpha(alpha: offset_y)
            
        case .ended:
            
            if let start = panStartTime?.timeIntervalSince1970 {
                let end = Date().timeIntervalSince1970
                if end - start > 1.0 {
                    UIView.animate(withDuration: 0.2) {
                        let transform1 = CGAffineTransform(translationX: 0, y: 0)
                        self.imageV.transform = CGAffineTransform(scaleX: 1, y: 1).concatenating(transform1)
                        self.delegate?.backgroundAlpha(alpha: 1)
                    }
                } else {
                    if listCellF == nil {
                        let y = ( movePoint.y > UIScreen.main.bounds.height / 2.0 ) ?  UIScreen.main.bounds.height + 30 : -30
                        listCellF = CGRect(x: movePoint.x, y: y, width: 30, height: 30)
                    }
                    hiddenAction()
                }
            } else {
                if listCellF == nil {
                    let y = ( movePoint.y > UIScreen.main.bounds.height / 2.0 ) ?  UIScreen.main.bounds.height + 30 : -30
                    listCellF = CGRect(x: movePoint.x, y: y, width: 30, height: 30)
                }
                hiddenAction()
            }
        default:
            break
        }
        
    }
    /// 单击
    @objc func imageViewSingleTapAction(ges: UIPanGestureRecognizer) {
        scrollView.setZoomScale(1, animated: true)
        scrollView.contentOffset = .zero
        hiddenAction()
    }
    
    /// 双击
    @objc func imageViewDoubleTapAction(ges: UIPanGestureRecognizer) {
        scrollView.setZoomScale(((scrollView.zoomScale == 1) ? 2 : 1), animated: true)
    }
    
    /// 长按
    @objc func imageViewLongPressAction(ges: UILongPressGestureRecognizer) {
        if ges.state == .began {
            if let img = imageV.image {
                longPressEvent?(img)
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = CGRect(origin: CGPoint.zero, size: contentView.bounds.size)
        
    }
    
    
}
// MARK: - UIGestureRecognizerDelegate
extension TSRPhotoBrowserCollectionViewCell: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if gestureRecognizer == panGes {
            firstTouchPoint = touch.location(in: self.window)
        }
        return true
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if firstTouchPoint == nil {
            return true
        }
        
        let touchPoint = gestureRecognizer.location(in: self.window)
        let dirTop = firstTouchPoint!.y - touchPoint.y
        if dirTop > -10 && dirTop < 10 {
            return false
        }
        
        let dirLieft = firstTouchPoint!.x - touchPoint.x
        if dirLieft > -10 && dirLieft < 10 && imageV.frame.size.height > UIScreen.main.bounds.size.height {
            return false
        }
        
        return true
    }
}

// MARK: - UIScrollViewDelegate
extension TSRPhotoBrowserCollectionViewCell: UIScrollViewDelegate {
    
    /// 缩放图片的时候将图片放在中间
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let offsetX = scrollView.bounds.size.width > scrollView.contentSize.width ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0
        let offsetY = scrollView.bounds.size.height > scrollView.contentSize.height ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0
        imageV.center = CGPoint(x: scrollView.contentSize.width * 0.5 + offsetX, y: scrollView.contentSize.height * 0.5 + offsetY)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }
    
    
}
