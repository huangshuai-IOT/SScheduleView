//
//  SScheduleScrollView.swift
//  SScheduleView
//
//  Created by 黄帅 on 2017/3/21.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit
import MJRefresh

public protocol SScheduleScrollViewDelegate:class {
    func pullSScheduleScrollViewStartRefreshing(_ ahScheduleScrollView:SScheduleScrollView)
}

open class SScheduleScrollView: UIScrollView {
    weak var pullDelegate:SScheduleScrollViewDelegate?
    
    var isRefreshing:Bool = false
    
    var isLoadingMore:Bool = false
    
    open func beginRefresh() {
        isRefreshing = true
        mj_header.beginRefreshing()
    }
    
    open func endRefresh() {
        isRefreshing = false
        mj_header.endRefreshing()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addRefreshView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addRefreshView()
    }
    
    private func addRefreshView() {
        self.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            self.isRefreshing = true
            self.pullDelegate?.pullSScheduleScrollViewStartRefreshing(self)
        })
    }
}
