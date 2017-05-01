//
//  ViewController.swift
//  SScheduleView_Example
//
//  Created by 黄帅 on 2017/4/26.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit
import SScheduleView

class ViewController: UIViewController {

    @IBOutlet weak var scheduleView: SScheduleView!
    
    // 开学日期
    let StartDate = "2017-02-13"
    
    // 显示的课表数据
    var thisWeekCourse = Array<SScheduleViewModelProtocol>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scheduleView.setTermStartDate(with: StartDate)
        scheduleView.setWeekIsShow(with: false)
        scheduleView.delegate = self
        
        initData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initData() {
        let course1 = CourseModel()
        course1.courseName = "机器学习"
        course1.classRoom = "1号楼202"
        course1.dayNum = 2
        course1.jieNum = 4
        course1.courseSpan = 4
        thisWeekCourse.append(course1)
        
        scheduleView.updateCourseView(courseDataList: thisWeekCourse)
    }
}

extension ViewController:SScheduleViewDelegate {
    func tapCourse(courseModel:SScheduleViewModelProtocol) {
        
    }
    
    func swipeGestureRight() {
        
    }
    
    func swipeGestureLeft() {
        
    }
    
    func pullAHScheduleScrollViewStartRefreshing(_ scheduleScrollView:SScheduleScrollView) {
        
    }
}
