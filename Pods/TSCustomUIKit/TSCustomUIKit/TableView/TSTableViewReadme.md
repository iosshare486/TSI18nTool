# TSTableView

```
制作简易列表UI时，快速创建tableview
```

## Usage

<pre> 
// 初始化
tableView = TSTableView(frame: CGRect.zero, createStyle: [.refresh, .loading, .initCell, .selectCell], refresh: {
//下拉刷新事件
}, loading: {
//上拉加载事件
}, initCell: { (cell, index) in
//创建cell时若需对cell做特殊处理，在此处可以拿到cell（如：cell中有某个闭包需要实现）
}, selectCell: { (index) in
//选中某条cell
})


// 设置数据源 
-------- 不分组列表设置数据源方式 ------
//1.普通方式，默认清除之前的数据源
self.mainTableView.setDatas(datas: datas)
//2.若设置数据源需在原基础上添加，则isLoading=true(即是上拉加载更多)
self.mainTableView.setDatas(datas: datas, isLoading: true or false)
//3.若在设置数据源时需特殊操作，则使用此方式，此方式设置时会清空原数据源重新赋值
self.mainTableView.setDatas(dataOperation: { (originDatas) -> [TSTableViewCellCreateDelegate] in

//do somethings

return datas
})

-------- 需要分组列表设置数据源方式 ------
//1.普通方式，默认清除之前的数据源
self.mainTableView.setGroupDatas(datas: datas)
//2.若设置数据源需在原基础上添加，则isLoading=true(即是上拉加载更多)
self.mainTableView.setGroupDatas(datas: datas, isLoading: true or false)
//3.若在设置数据源时需特殊操作，则使用此方式，此方式设置时会清空原数据源重新赋值
self.mainTableView.setGroupDatas(dataOperation: { (originDatas) -> [TSTableViewSectionHeaderDelegate] in

//do somethings

return datas
})


// model配置

//cell对应的model需要遵守TSTableViewCellCreateDelegate协议，并实现返回cell的方法

struct MJToodayPredictions: HandyJSON,Codable, TSTableViewCellCreateDelegate {

var somekey: Any

func ts_getCell(tableView: UITableView) -> UITableViewCell {

var cell : MJFBMatchIndexCell? = tableView.dequeueReusableCell(withIdentifier: "MJCollectionUnfinishedCellId") as? MJFBMatchIndexCell
if cell == nil {
cell = MJFBMatchIndexCell(style: .default, reuseIdentifier: "MJCollectionUnfinishedCellId")
cell?.isShowDate = true
}
cell?.updateMatchIndex(match: self)
return cell!
}
}

// 每一组section对应的model需遵守TSTableViewSectionHeaderDelegate协议
struct MJMyMatchSectionData: HandyJSON, TSTableViewSectionHeaderDelegate {

var time: String?
var time_str: String?
var data: [MJToodayPredictions]?

func ts_getSection(tableView: UITableView) -> UITableViewHeaderFooterView? {

var header: MJCollectionMatchSecHeader? = tableView.dequeueReusableHeaderFooterView(withIdentifier: "MJCollectionMatchSecHeaderId") as? MJCollectionMatchSecHeader
if header == nil {
header = MJCollectionMatchSecHeader(reuseIdentifier: "MJCollectionMatchSecHeaderId")
}
if self.time_str != nil {
header?.teamInfo.text = self.time_str ?? ""
}
return header
}

func ts_getCurrentSectionDatas() -> [TSTableViewCellCreateDelegate] {

return self.data ?? []
}

}

</pre>
