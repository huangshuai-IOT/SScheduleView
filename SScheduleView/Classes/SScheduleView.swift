//
//  SScheduleView.swift
//  SScheduleView
//
//  Created by 黄帅 on 2017/3/21.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit
import SnapKit

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

public protocol SScheduleViewDelegate:class {
    func tapCourse(courseModel:SScheduleViewModelProtocol)
    func swipeGestureRight()
    func swipeGestureLeft()
    func pullAHScheduleScrollViewStartRefreshing(_ scheduleScrollView:SScheduleScrollView)
}

open class SScheduleView: UIView {
    /// 其他列宽度 与 第一列宽度 比
    @IBInspectable var sideColWidthRatio:CGFloat = 2 {
        didSet {
            resetLayout()
        }
    }

    /// 顶部日期栏 View 背景色
    @IBInspectable var headViewBackgroundColor: UIColor = SScheduleTheme.BlankAreaColor {
        didSet {
            resetLayout()
        }
    }

    /// 侧边时间栏 View 背景色
    @IBInspectable var sideViewBackgroundColor: UIColor = SScheduleTheme.BlankAreaColor {
        didSet {
            resetLayout()
        }
    }
    
    var courseDataList = Array<SScheduleViewModelProtocol>()
    
    open weak var delegate:SScheduleViewDelegate?
    
    /// 一共显示的天数
    fileprivate var showDaysNum:CGFloat = 5
    /// 一共显示的课程节数
    fileprivate var showJiesNum:CGFloat = 11
    /// 当前显示的周数
    fileprivate var showWeekNum:Int = 1
    /// 开学日期
    fileprivate var termStartDate = Date()
    /// 第一行是否显示当前周数
    fileprivate var isShowWeekNum: Bool = true
    
    /// 第一列的宽度
    open var firstColumnWidth:CGFloat!
    /// 非第一列,其他每一列的宽度
    open var notFirstEveryColumnsWidth:CGFloat!
    /// 第一行的高度
    open var firstRowHeight:CGFloat!
    /// 非第一行,其他每一行的高度
    open var notFirstEveryRowHeight:CGFloat!
    
    /// 第一行显示资源
    fileprivate let titleNames = ["周一","周二","周三","周四","周五","周六","周日"]
    /// 第一行显示日期
    fileprivate var datesOfMonth:[String]!
    
    /// 顶部 View
    public var headView:UIView!
    /// 侧边课程节数 View
    public var sideView:UIView!
    /// 课程内容 View
    public var contentView:UIView!
    
    /// 设置一周显示的天数
    ///
    /// - Parameter num: 一周显示的天数
    open func setShowTotalDay(with num:CGFloat) {
        self.showDaysNum = num
        resetLayout()
    }
    
    /// 设置显示周数
    ///
    /// - Parameter num: 第几周
    open func setShowWeek(with num:Int) {
        self.showWeekNum = num
        updateHeadView()
    }
    
    /// 设置是否显示当前周数，因为有的ViewController在NavigationBar显示当前周数
    ///
    /// - Parameter isShow: 是否显示
    open func setWeekIsShow(with isShow:Bool) {
        self.isShowWeekNum = isShow
        updateHeadView()
    }
    
    /// 当前学期开学时间 "yyyy-MM-dd"
    ///
    /// - Parameter dateString: such as “2017-02-15”
    open func setTermStartDate(with dateString:String) {
        let dateFmt = DateFormatter()
        dateFmt.dateFormat = "yyyy-MM-dd"
        self.termStartDate = dateFmt.date(from: dateString)!
        let from = self.termStartDate.timeIntervalSince1970
        let now = (Date().timeIntervalSince1970)
        var week = Int((now - from)/(7 * 24 * 3600)) + 1
        if week < 1 {
            week = 0
        }
        self.showWeekNum = week
        updateHeadView()
    }
    
    /// 清空课表数据，可用于账户退出登录后的操作
    open func clearOldCourseView() {
        _ = contentView.subviews.map {
            $0.removeFromSuperview()
        }
    }
    
    /// 显示课程数据
    ///
    /// - Parameter courseDataList: 课程数据
    open func updateCourseView(courseDataList:Array<SScheduleViewModelProtocol>) {
        self.courseDataList = courseDataList
        clearOldCourseView()
        updateCourseView()
    }
    
    open func setCourseViewIsCornor(_ isCornor:Bool) {
        
    }
    
    /// 根据Location获取CourseDataModel
    ///
    /// - Parameter location: location in SSCheduleView
    /// - Returns: SScheduleViewModelProtocol
    open func getDataModel(with location: CGPoint) -> SScheduleViewModelProtocol? {
        for view in contentView.subviews {
            if view.frame.contains(location) && view is SScheduleCourseView{
                return (view as! SScheduleCourseView).model
            }
        }
        return nil
    }
    
    /**
     * 初始化
     */
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initUI()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    override open func prepareForInterfaceBuilder() {
        initUI()
    }
    
    /// 重绘整个UI
    fileprivate func resetLayout() {
        _ = self.subviews.map { view in
            view.removeFromSuperview()
        }
        
        initUI()
        updateCourseView()
    }
    
    fileprivate func initUI() {
        initUISize()
        drawFirstRow()
        drawOtherRows()
        addContentViewGesture()
    }
    
    /// 设置UI的各个Size
    open func initUISize() {
        firstColumnWidth = self.bounds.width / (sideColWidthRatio * showDaysNum + 1)
        notFirstEveryColumnsWidth = firstColumnWidth * sideColWidthRatio
        
        firstRowHeight = 30
        notFirstEveryRowHeight = (self.bounds.height - firstRowHeight) / showJiesNum
    }
    
    /// 绘制第一行表头UI
    open func drawFirstRow() {
        headView = UIView()
        headView.backgroundColor = headViewBackgroundColor
        addSubview(headView)
        headView.snp.makeConstraints{
            $0.left.top.right.equalTo(self)
            $0.height.equalTo(firstRowHeight)
        }
        drawFirstRowFirstColCell()
        drawFirstRowOtherColCell()
    }
    
    /// 绘制课表下方UI，整个下方是一个scrollView
    open func drawOtherRows() {
        let scrollView = SScheduleScrollView()
        scrollView.pullDelegate = self
        addSubview(scrollView)
        scrollView.snp.makeConstraints{
            $0.top.equalTo(self).offset(firstRowHeight)
            $0.right.left.bottom.equalTo(self)
        }
        
        drawOtherRowFirstCol(scrollView: scrollView)
        drawOtherRowOtherCol(scrollView: scrollView)
    }
    
    /// 绘制第一行第一列,即当前周数和月份
    open func drawFirstRowFirstColCell() {
        let view = UIView()
        headView.addSubview(view)
        view.snp.makeConstraints {
            $0.left.top.bottom.equalTo(headView)
            $0.width.equalTo(firstColumnWidth)
        }
        
        if isShowWeekNum {
            let weekNumLabel = UILabel()
            weekNumLabel.text = "第\(showWeekNum)周"
            weekNumLabel.font = UIFont.boldSystemFont(ofSize: 10)
            view.addSubview(weekNumLabel)
            weekNumLabel.snp.makeConstraints {
                $0.centerX.top.equalTo(view)
                $0.height.equalTo(firstRowHeight / 2)
            }
        }
        
        let monthNumLabel = UILabel()
        monthNumLabel.text = getMonth(startTermDate: termStartDate, week: showWeekNum) + "月"
        monthNumLabel.font = UIFont.systemFont(ofSize: 10)
        view.addSubview(monthNumLabel)
        monthNumLabel.snp.makeConstraints {
            $0.centerX.bottom.equalTo(view)
            $0.height.equalTo(firstRowHeight / 2)
        }
    }
    
    /// 绘制第一行其他列，即周几+日期
    open func drawFirstRowOtherColCell() {
        // 获取每天对应的日期
        let daysList = getDaysListForWeek(startTermDate: termStartDate, week: showWeekNum)
        
        for i in 0 ..< Int(showDaysNum) {
            let view = UIView()
            headView.addSubview(view)
            view.snp.makeConstraints{
                $0.top.height.equalTo(headView)
                $0.left.equalTo(headView).offset(notFirstEveryColumnsWidth * CGFloat(i) + firstColumnWidth)
                $0.width.equalTo(notFirstEveryColumnsWidth)
            }
            
            let dayLabel = UILabel()
            dayLabel.text = titleNames[i]
            dayLabel.font = UIFont.boldSystemFont(ofSize: 10)
            view.addSubview(dayLabel)
            dayLabel.snp.makeConstraints{
                $0.centerX.top.equalTo(view)
                $0.height.equalTo(firstRowHeight / 2)
            }
            
            let dateLabel = UILabel()
            dateLabel.text = "\(daysList[i])号"
            dateLabel.font = UIFont.systemFont(ofSize: 10)
            view.addSubview(dateLabel)
            dateLabel.snp.makeConstraints{
                $0.centerX.bottom.equalTo(view)
                $0.top.equalTo(dayLabel.snp.bottom)
            }
            
            let seperateView = UIView()
            seperateView.backgroundColor = SScheduleTheme.SeperatorColor
            view.addSubview(seperateView)
            seperateView.snp.makeConstraints {
                $0.width.equalTo(0.5)
                $0.left.top.bottom.equalTo(view)
            }
        }
    }
    
    // 绘制其他行第一列,即sideView,课程节数列
    ///
    /// - Parameter scrollView:
    open func drawOtherRowFirstCol(scrollView:UIScrollView) {
        sideView = UIView()
        sideView.backgroundColor = sideViewBackgroundColor
        scrollView.addSubview(sideView)
        sideView.snp.makeConstraints{
            $0.left.equalTo(self)
            $0.top.bottom.equalTo(scrollView)
            $0.width.equalTo(firstColumnWidth)
            $0.height.equalTo(notFirstEveryRowHeight * showJiesNum)
        }
        
        for i in 0 ..< Int(showJiesNum) {
            let jieciLabel = UILabel()
            jieciLabel.text = "\(i+1)"
            jieciLabel.font = UIFont.systemFont(ofSize: 10)
            jieciLabel.textAlignment = NSTextAlignment.center
            sideView.addSubview(jieciLabel)
            jieciLabel.snp.makeConstraints{
                $0.top.equalTo(sideView.snp.top).offset(notFirstEveryRowHeight * CGFloat(i))
                $0.right.left.equalTo(sideView)
                $0.height.equalTo(notFirstEveryRowHeight)
            }
            
            let seperateView = UIView()
            seperateView.backgroundColor = SScheduleTheme.SeperatorColor
            sideView.addSubview(seperateView)
            seperateView.snp.makeConstraints{
                $0.height.equalTo(0.5)
                $0.top.right.left.equalTo(jieciLabel)
            }
        }
    }
    
    /// 绘制其他行其他列
    ///
    /// - Parameter scrollView:
    open func drawOtherRowOtherCol(scrollView:UIScrollView) {
        contentView = UIView()
        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints{
            $0.right.equalTo(self)
            $0.top.bottom.equalTo(sideView)
            $0.left.equalTo(sideView.snp.right)
        }
    }
    
    /// 给课表区域增加左右滑动切换周数的手势
    open func addContentViewGesture() {
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.viewSwpie(_:)))
        swipeRightGesture.direction = .right
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action:#selector(self.viewSwpie(_:)))
        swipeLeftGesture.direction = .left
        contentView.addGestureRecognizer(swipeRightGesture)
        contentView.addGestureRecognizer(swipeLeftGesture)
    }
    
    /// 绘制课程信息
    open func updateCourseView() {
        for data in courseDataList {
            /* 设置课程格子的背景View */
            let courseBackView = SScheduleCourseView()
            courseBackView.delegate = self
            courseBackView.setupUI(with: data)
            contentView.addSubview(courseBackView)
            courseBackView.snp.makeConstraints{
                $0.width.equalTo(notFirstEveryColumnsWidth)
                $0.height.equalTo(notFirstEveryRowHeight * CGFloat(data.getSpan()))
                $0.left.equalTo(contentView).offset(notFirstEveryColumnsWidth * CGFloat(data.getDay() - 1))
                $0.top.equalTo(contentView).offset(notFirstEveryRowHeight * CGFloat(data.getJieci() - 1))
            }
        }
    }
    
    @objc fileprivate func viewSwpie(_ sender:UISwipeGestureRecognizer) {
        if sender.direction == UISwipeGestureRecognizerDirection.right {
            if showWeekNum > 1 {
                showWeekNum = showWeekNum - 1
                setShowWeek(with: showWeekNum)
                delegate?.swipeGestureRight()
            }
        } else if sender.direction == UISwipeGestureRecognizerDirection.left {
            showWeekNum = showWeekNum + 1
            setShowWeek(with: showWeekNum)
            delegate?.swipeGestureLeft()
        }
    }
    
    /// 更新表头View
    fileprivate func updateHeadView() {
        headView.removeFromSuperview()
        drawFirstRow()
    }
}

extension SScheduleView:SScheduleCourseViewProtocol {
    public func tapCourse(courseModel:SScheduleViewModelProtocol) {
        delegate?.tapCourse(courseModel: courseModel)
    }
}

extension SScheduleView:SScheduleScrollViewDelegate {
    public func pullSScheduleScrollViewStartRefreshing(_ ahScheduleScrollView:SScheduleScrollView) {
        delegate?.pullAHScheduleScrollViewStartRefreshing(ahScheduleScrollView)
    }
}

// MARK: - 一些操作方法
extension SScheduleView {
    
    /// 获取指定范围内的随机数
    ///
    /// - Parameter range: 随机数范围
    /// - Returns: 随机数
    fileprivate func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
    
    /// 获取本学期指定周数的月份
    ///
    /// - Parameters:
    ///   - startTermDate: 本学期开始日期
    ///   - week: 指定周数
    /// - Returns: 月份
    fileprivate func getMonth(startTermDate:Date , week:Int) -> String {
        var startDate = Int(startTermDate.timeIntervalSince1970)
        startDate = startDate + ((week - 1) * 7 * 24 * 3600)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "M"
        
        let timeInterval = TimeInterval(startDate)
        let date = Date(timeIntervalSince1970: timeInterval)
        let string = formatter.string(from: date)
        
        return string
    }
    
    /// 获取本学期指定周数的每日日期
    ///
    /// - Parameters:
    ///   - startTermDate: 本学期开始日期
    ///   - week: 指定周数
    /// - Returns: 每日日期
    fileprivate func getDaysListForWeek(startTermDate:Date , week:Int) -> [String] {
        var startDate = Int(startTermDate.timeIntervalSince1970)
        startDate = startDate + ((week - 1) * 7 * 24 * 3600)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        
        var weekString:[String] = []
        
        for i in 0..<7 {
            let day = startDate + (i * 24 * 3600)
            let timeInterval = TimeInterval(day)
            let date = Date(timeIntervalSince1970: timeInterval)
            let string = formatter.string(from: date)
            weekString.append(string)
        }
        
        return weekString
    }
}
