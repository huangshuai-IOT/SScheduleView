//
//  SScheduleCourseView.swift
//  SScheduleView
//
//  Created by 黄帅 on 2017/3/27.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit
import SnapKit
public protocol SScheduleCourseViewProtocol:class {
    func tapCourse(courseModel:SScheduleViewModelProtocol)
}

open class SScheduleCourseView: UIView {
    
    public var model:SScheduleViewModelProtocol!
    
    private var courseInfoButton:UIButton!
    
    public var courseInfoAlpha:CGFloat = 1.0 {
        didSet {
            courseInfoButton.backgroundColor = courseInfoButton.backgroundColor?.withAlphaComponent(courseInfoAlpha)
        }
    }
    
    weak var delegate:SScheduleCourseViewProtocol?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open func setupUI(with model:SScheduleViewModelProtocol) {
        self.model = model
        self.backgroundColor = UIColor.clear
        let courseBackView = UIView()
        courseBackView.backgroundColor = UIColor.clear
        courseBackView.isUserInteractionEnabled = true
        addSubview(courseBackView)
        courseBackView.snp.makeConstraints{
            $0.bottom.top.right.left.equalTo(self)
        }
        
        /* 设置课程格子显示Button */
        courseInfoButton = UIButton()
        courseInfoButton.setTitle(self.model.getCourseName() + "\n" + self.model.getClassRoom(), for: UIControlState.normal)
        courseInfoButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
        
        courseInfoButton.contentHorizontalAlignment = .center
        courseInfoButton.contentVerticalAlignment = .center
        courseInfoButton.contentEdgeInsets = UIEdgeInsetsMake(1, 2, 1, 2)
        courseInfoButton.titleLabel?.numberOfLines = 0
        courseInfoButton.backgroundColor = self.model.getBackColor() ?? SScheduleTheme.flatColors[randomInRange(0..<17)].color
        
        // 增加课程点击事件
        courseInfoButton.addTarget(self, action: #selector(self.courseInfoButtonTouch(sender:)), for: UIControlEvents.touchUpInside)
        
        addSubview(courseInfoButton)
        courseInfoButton.snp.makeConstraints{
            $0.edges.equalTo(courseBackView).inset(UIEdgeInsetsMake(1, 1, 1, 1))
        }
    }
    
    @objc fileprivate func courseInfoButtonTouch(sender:UIButton) {
        delegate?.tapCourse(courseModel: self.model)
    }
}
extension SScheduleCourseView {
    /// 获取指定范围内的随机数
    ///
    /// - Parameter range: 随机数范围
    /// - Returns: 随机数
    fileprivate func randomInRange(_ range: Range<Int>) -> Int {
        let count = UInt32(range.upperBound - range.lowerBound)
        return  Int(arc4random_uniform(count)) + range.lowerBound
    }
}
