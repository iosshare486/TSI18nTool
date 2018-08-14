//
//  TSRPhotoBrowserView.swift
//  TSSocialTest
//
//  Created by 彩球 on 2018/7/1.
//  Copyright © 2018年 caiqr. All rights reserved.
//

import UIKit


private enum TSRShowImgMode {
    case none, url, location
}

@objc public protocol TSRPhotoBrowserViewDelegate {
    
    func longPressGestureRecognizerEvent(img: UIImage)
}

open class TSRPhotoBrowserView: UIView {
    
    //Delegate
    @objc public var delegate: TSRPhotoBrowserViewDelegate?
    /// 源图片地址数组
    @objc open var originUrls: [String]?
    /// 缩略图地址数组
    @objc open var thumbnailUrls: [String]?
    /// 本地图片数组
    @objc open var locationImages: [UIImage]?
    
    @objc public var originRect: [CGRect]?
    @objc open var selectIndex: Int = 0
    
    
    private var isFirstOpen: Bool = true
    private var isExistting: Bool = false
    private var isShowUrlMode: TSRShowImgMode = .none
    private var isUseThumbnail: Bool = false
    
    private var collectionView: UICollectionView!
    private var pageControl: UIPageControl!
    
    private let cellIdentifier = "TSRPhotoBrowserCollectionViewCellId"
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        pageControl.center = CGPoint(x: center.x, y: frame.size.height - 50)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createViews() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = UIScreen.main.bounds.size
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = originRect != nil ? .clear : .black
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isPagingEnabled = true
        collectionView.register(TSRPhotoBrowserCollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
        addSubview(collectionView)
        
        pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        addSubview(pageControl)
        
    }
    
    
    private func handleCurrentPage(idx: Int) {
        
    }
    
    private func setSelectIndex(_ idx: Int) {
        
        collectionView.setContentOffset(CGPoint(x: UIScreen.main.bounds.size.width * CGFloat(idx), y: 0), animated: false)
        
    }
    
    /// show
    @objc public func show() {
        
        if self.locationImages != nil, self.locationImages!.count > 0 {
            isShowUrlMode = .location
        }
        
        if self.originUrls != nil && self.originUrls!.count > 0 {
            isShowUrlMode = .url
            if self.thumbnailUrls != nil && self.thumbnailUrls!.count > 0 && self.thumbnailUrls!.count == self.originUrls!.count {
                isUseThumbnail = true
            }
        }
        
        guard isShowUrlMode != .none else {
            debugPrint("image source is nil")
            return
        }
        
        
        if !isExistting {
            isExistting = true
            UIApplication.shared.keyWindow?.addSubview(self)
            self.frame = UIScreen.main.bounds
        }
        
        if isShowUrlMode == .location {
            pageControl.numberOfPages = locationImages!.count
            pageControl.isHidden = locationImages!.count < 2
        } else if isShowUrlMode == .url {
            pageControl.numberOfPages = originUrls!.count
            pageControl.isHidden = originUrls!.count < 2
        } else {
            pageControl.isHidden = true
        }
        
        if selectIndex < pageControl.numberOfPages {
            pageControl.currentPage = selectIndex
        }
        
        collectionView.reloadData()
        
        setSelectIndex(selectIndex)
        
    }
}

extension TSRPhotoBrowserView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isShowUrlMode == .location {
            return locationImages!.count
        }else if isShowUrlMode == .url {
            return originUrls!.count
        } else {
            return 0
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: TSRPhotoBrowserCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! TSRPhotoBrowserCollectionViewCell
        
        cell.isFirstLoad = isFirstOpen
        if isFirstOpen {
            isFirstOpen = false
        }
        
        cell.longPressEvent = { [weak self] (img) in
            if let ws = self {
                ws.delegate?.longPressGestureRecognizerEvent(img: img)
            }
        }
        
        if self.originRect != nil && self.originRect!.count > indexPath.row {
            cell.listCellF = self.originRect![indexPath.row]
        } else {
            cell.listCellF = nil
        }
        
        if isShowUrlMode == .location {
            cell.setPicImage(locationImages![indexPath.row])
        }
        
        if isShowUrlMode == .url {
            
            cell.setPicURL(originURLStr: originUrls![indexPath.row], thumbnailURLStr: isUseThumbnail ? thumbnailUrls![indexPath.row] : nil)
        }
        cell.delegate = self
        return cell
    }
    
}

extension TSRPhotoBrowserView: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = scrollView.contentOffset.x / UIScreen.main.bounds.size.width
        pageControl.currentPage = Int(currentPage)
        handleCurrentPage(idx: Int(currentPage))
    }
    
}

extension TSRPhotoBrowserView: TSRPhotoBrowserCollectionViewCellDelegate {
    
    func backgroundAlpha(alpha: CGFloat) {
        collectionView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha)
        pageControl.alpha = alpha
    }
    
    
    func hiddenAction(cell: TSRPhotoBrowserCollectionViewCell) {
        
        //        let indexPath = collectionView.indexPath(for: cell)
        UIView.animate(withDuration: 0.5, animations: {
            self.collectionView.backgroundColor = .clear
            if cell.listCellF != nil {
                cell.imageV.frame = cell.listCellF!
            } else {
                cell.imageV.alpha = 0
            }
            
        }) { (ret) in
            self.isExistting = false
            self.isFirstOpen = true
            self.removeFromSuperview()
        }
        
    }
}









