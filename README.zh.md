# SScheduleView

![Swift 3.0](https://img.shields.io/badge/Swift-3.0-brightgreen.svg?style=flat)
[![Version](https://img.shields.io/cocoapods/v/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![License](https://img.shields.io/cocoapods/l/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![Platform](https://img.shields.io/cocoapods/p/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![Weibo](https://img.shields.io/badge/%e5%be%ae%e5%8d%9a-%40%e9%bb%84%e5%b8%85IOT-yellow.svg?style=flat)](http://weibo.com/2189929640)

iOS 课程表控件，方便快速集成。

[English Document](https://github.com/huangshuai-IOT/SScheduleView/blob/master/README.md)

## 介绍
本项目基于 UIKit 使用 Swift3 绘制的课程表控件，方便快速集成。

## 功能
- 根据课程周显示本周日期
- 支持左右手势滑动
- 动态设置周末课程显示
- 动态修改显示课程

## 要求
- iOS 8 +
- Xcode 8
- Swift 3

## 安装
### CocoaPods
#### Swift3

```ruby
target 'ProjectName' do
    use_frameworks!
    pod 'SScheduleView'
end
```

### Carthage
TODO

### Demo
运行 Demo ，请下载后先在 Example 目录运行 `pod install`

## 使用 （支持IB和代码）
### IB用法
直接拖 UIView 到 IB 上，设置 UIView 的 class 为 SScheduleView 即可，代码部分只需要实现。更多细节请看Demo。

### 代码布局（[SnapKit](https://github.com/SnapKit/SnapKit)）

```swift
import SScheduleView

scheduleView = SScheduleView()
view.addSubview(scheduleView)
scheduleView { (make) in
    make.top.equalTo(self.view).offset(44)
    make.left.right.bottom.equalTo(self.view)
}
scheduleView.delegate = self
```

### 绑定显示课表数据
应用的课程表数据类型应该实现 `SScheduleViewModelProtocol` 协议

```swift
public protocol SScheduleViewModelProtocol {
    // 周几的课 从1开始
    func getDay() -> Int
    // 第几节课 从1开始
    func getJieci() -> Int
    //一节课的持续时间
    func getSpan() -> Int
    func getCourseName() -> String
    func getClassRoom() -> String
    // 课程的自定义颜色，若nil则采用随机颜色
    func getBackColor() -> UIColor?
}
```

之后，调用更新数据函数，即可显示课表数据

```swift 
var thisWeekCourse = Array<SScheduleViewModelProtocol>()
scheduleView.updateCourseView(courseDataList: thisWeekCourse)
```

### 监听状态变化
具体用法请看 Example 项目

#### 协议方式
```swift
public protocol SScheduleViewDelegate:class {
    func tapCourse(courseModel:SScheduleViewModelProtocol)
    func swipeGestureRight()
    func swipeGestureLeft()
    func pullAHScheduleScrollViewStartRefreshing(_ scheduleScrollView:SScheduleScrollView)
}
```

## SScheduleView 自定义属性
```swift
/// 其他列宽度 与 第一列宽度 比
@IBInspectable var sideColWidthRatio:CGFloat = 2 

/// 顶部日期栏 View 背景色
@IBInspectable var headViewBackgroundColor: UIColor = SScheduleTheme.BlankAreaColor 

/// 侧边时间栏 View 背景色
@IBInspectable var sideViewBackgroundColor: UIColor = SScheduleTheme.BlankAreaColor 

/// 设置一周显示的天数
open func setShowTotalDay(with num:CGFloat)

/// 设置显示周数
open func setShowWeek(with num:Int)

/// 设置是否显示当前周数，因为有的ViewController在NavigationBar显示当前周数
open func setWeekIsShow(with isShow:Bool)

/// 当前学期开学时间 "yyyy-MM-dd"
open func setTermStartDate(with dateString:String) 

/// 清空课表数据，可用于账户退出登录后的操作
open func clearOldCourseView() 
```

## 联系我
- 微博: [黄帅IOT](http://weibo.com/u/2189929640)
- 博客: https://huangshuai-iot.github.io/
- 邮箱: shuai.huang.iot@foxmail.com

## 贡献者
欢迎提交 issue 和 PR，大门永远向所有人敞开。

## License
SScheduleView is available under the MIT license. See the LICENSE file for more info.


