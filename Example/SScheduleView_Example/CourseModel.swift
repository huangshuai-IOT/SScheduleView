//
//  CourseModel.swift
//  SScheduleView_Example
//
//  Created by 黄帅 on 2017/4/28.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit
import SScheduleView

class CourseModel: NSObject {
    // 周几
    var dayNum = 0
    
    // 第几节课
    var jieNum = 0
    
    // 课程长度
    var courseSpan = 0
    
    // 课程名称
    var courseName = ""
    
    // 课程地点
    var classRoom = ""
    
    // 课程颜色,使用HexString方便保存
    var colorString = ""
}

extension CourseModel:SScheduleViewModelProtocol {
    // 周几的课 从1开始
    func getDay() -> Int {
        return dayNum
    }
    
    // 第几节课 从1开始
    func getJieci() -> Int {
        return jieNum
    }
    
    //一节课的持续时间
    func getSpan() -> Int {
        return courseSpan
    }
    
    func getCourseName() -> String {
        return courseName
    }
    
    func getClassRoom() -> String {
        return classRoom
    }
    
    // 课程的自定义颜色，若nil则采用随机颜色
    func getBackColor() -> UIColor? {
        if colorString != "" {
            return UIColor(hexString: colorString)
        } else {
            return nil
        }
    }
}

