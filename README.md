# SScheduleView
![Swift 3.0](https://img.shields.io/badge/Swift-3.0-brightgreen.svg?style=flat)
[![Version](https://img.shields.io/cocoapods/v/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![License](https://img.shields.io/cocoapods/l/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![Platform](https://img.shields.io/cocoapods/p/SScheduleView.svg?style=flat)](http://cocoapods.org/pods/SScheduleView)
[![Weibo](https://img.shields.io/badge/%e5%be%ae%e5%8d%9a-%40%e9%bb%84%e5%b8%85IOT-yellow.svg?style=flat)](http://weibo.com/2189929640)

School ScheduleView for iOS, pure swift.

[中文文档](https://github.com/huangshuai-IOT/SScheduleView/blob/master/README.zh.md)

## Features
- Show weekdays date based on course week
- Support left and right gestures to slide
- Dynamically set the weekend course display
- Dynamic changes show course

![Demo](https://github.com/huangshuai-IOT/SScheduleView/blob/master/demo.gif)

## Requirements
- iOS 8 +
- Xcode 8 
- Swift 3

## Installation
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
run `pod install` at `Example` folder before run the demo.

## Usage （Support IB and code）
### IB usage
Direct drag IB to UIView, set the UIView class to SScheduleView，the code section only needs to achieve. See more detail on the demo.

### Code implementation by [SnapKit](https://github.com/SnapKit/SnapKit)
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

### Bind Displays the schedule data
The application's data type should implement the `SScheduleViewModelProtocol` protocol

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

After that, call the update data function to display the lesson data

```swift 
var thisWeekCourse = Array<SScheduleViewModelProtocol>()
scheduleView.updateCourseView(courseDataList: thisWeekCourse)
```

### Listening to player state changes
See more detail from the Example project

#### Delegate

```swift
public protocol SScheduleViewDelegate:class {
    func tapCourse(courseModel:SScheduleViewModelProtocol)
    func swipeGestureRight()
    func swipeGestureLeft()
    func pullAHScheduleScrollViewStartRefreshing(_ scheduleScrollView:SScheduleScrollView)
}
```

## Customize SScheduleView

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

## Peek & Pop

```swift
extension viewController:UIViewControllerPreviewingDelegate {
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        
        if let model = scheduleView.getDataModel(with: self.view.convert(location, to: self.scheduleView)) {
          // return previewVC
        }
        
        return nil
    }
    
    public func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        show(viewControllerToCommit, sender: self)
    }
}
```

## Contact me

- Weibo: [黄帅IOT](http://weibo.com/u/2189929640)
- Blog: https://huangshuai-iot.github.io/
- Email: shuai.huang.iot@foxmail.com

## Contributors

You are welcome to fork and submit pull requests.

## License
SScheduleView is available under the MIT license. See the LICENSE file for more info.

