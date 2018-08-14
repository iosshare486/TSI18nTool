//
//  TSTableView.swift
//  TSUIKit
//
//  Created by huangyuchen on 2018/6/30.
//  Copyright © 2018年 任鹏杰. All rights reserved.
//

import UIKit
import TSRefresh

public struct TSTableViewStyle: OptionSet {
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public var rawValue: Int
    
    public static let refresh = TSTableViewStyle(rawValue: 1 << 0)
    public static let loading = TSTableViewStyle(rawValue: 1 << 1)
    public static let initCell = TSTableViewStyle(rawValue: 1 << 2)
    public static let selectCell = TSTableViewStyle(rawValue: 1 << 3)
    public static let all = TSTableViewStyle(rawValue: 1 << 4)
    public static let none = TSTableViewStyle(rawValue: 1 << 5)
}


public protocol TSTableViewCellCreateDelegate {
    
    func ts_getCell(tableView: UITableView) -> UITableViewCell
}

public protocol TSTableViewSectionHeaderDelegate {
    
    func ts_getSection(tableView: UITableView) -> UITableViewHeaderFooterView?
    
    func ts_getCurrentSectionDatas()-> [TSTableViewCellCreateDelegate]
}

public class TSTableView: UITableView {
    
    public typealias refreshOperation = (()->Void)
    public typealias InitCellOperation = ((_ cell: UITableViewCell, _ index: IndexPath)->Void)
    public typealias SelectCellOperation = ((_ index: IndexPath)->Void)
    
    private var initCell: InitCellOperation?
    private var selectCell: SelectCellOperation?
    private var datas: [TSTableViewCellCreateDelegate] = [TSTableViewCellCreateDelegate]()
    private var groupDatas: [TSTableViewSectionHeaderDelegate] = [TSTableViewSectionHeaderDelegate]()
    private var isGroup: Bool = false//是否分组
    ///  由于声明逃逸闭包不能声明可选，为了模拟可选类型，添加了一个默认，若是默认值，则表示没有传，即可选为nil
    convenience public init(frame: CGRect, createStyle: TSTableViewStyle, refresh: @escaping refreshOperation = {}, loading: @escaping refreshOperation = {}, initCell: @escaping InitCellOperation = {(cell, index) in }, selectCell: @escaping SelectCellOperation = {(index) in }) {
        
        self.init(frame: frame, style: UITableViewStyle.plain)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.estimatedRowHeight = 200
        self.rowHeight = UITableViewAutomaticDimension
        self.separatorStyle = .none
        self.backgroundColor = .white
        
        if createStyle.contains(.refresh) || createStyle.contains(.all) {
            self.ts_addRefreshAction {
                refresh()
            }
        }
        if createStyle.contains(.loading) || createStyle.contains(.all)  {
            self.ts_addLoadMoreAction {
                loading()
            }
        }
        if createStyle.contains(.initCell) || createStyle.contains(.all)  {
            self.initCell = initCell
        }else {
            self.initCell = nil
        }
        if createStyle.contains(.selectCell) || createStyle.contains(.all)  {
            self.selectCell = selectCell
        }else {
            self.selectCell = nil
        }
        
        self.delegate = self
        self.dataSource = self
    }
    
    public func setDatas(datas: [TSTableViewCellCreateDelegate], isLoading: Bool = false) {
        
        self.isGroup = false
        if isLoading == false {
            self.datas.removeAll()
        }
        self.datas.append(contentsOf: datas)
        self.reloadData()
    }
    
    public func setDatas(dataOperation: ((_ originDatas: [TSTableViewCellCreateDelegate])->[TSTableViewCellCreateDelegate])) {
        
        self.isGroup = false
        let currentDatas = dataOperation(self.datas)
        
        self.datas.removeAll()
        
        self.datas.append(contentsOf: currentDatas)
        
        self.reloadData()
    }
    
    public func setGroupDatas(datas: [TSTableViewSectionHeaderDelegate], isLoading: Bool = false) {
        
        self.isGroup = true
        self.groupDatas.append(contentsOf: datas)
        self.reloadData()
    }
    
    public func setGroupDatas(dataOperation: ((_ originDatas: [TSTableViewSectionHeaderDelegate])->[TSTableViewSectionHeaderDelegate])) {
        
        self.isGroup = true
        let currentDatas = dataOperation(self.groupDatas)
        
        self.groupDatas.removeAll()
        
        self.groupDatas.append(contentsOf: currentDatas)
        
        self.reloadData()
    }
}


extension TSTableView: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.isGroup {
            
            let sectionDatas = self.groupDatas[indexPath.section].ts_getCurrentSectionDatas()
            
            let cell = sectionDatas[indexPath.row].ts_getCell(tableView: tableView)
            
            self.initCell?(cell, indexPath)
            
            return cell
        }else {
            
            let cell = self.datas[indexPath.row].ts_getCell(tableView: tableView)
            self.initCell?(cell, indexPath)
            return cell
        }
        
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        
        if isGroup {
            return self.groupDatas.count
        }else {
            return 1
        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.isGroup {
            return self.groupDatas[section].ts_getCurrentSectionDatas().count
        }else{
            return self.datas.count
        }
    }
    
    public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if self.isGroup {
            return self.groupDatas[section].ts_getSection(tableView: tableView)
        }else {
            return nil
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectCell?(indexPath)
    }
}
