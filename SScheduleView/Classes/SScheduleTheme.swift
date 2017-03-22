//
//  SScheduleTheme.swift
//  SScheduleView
//
//  Created by 黄帅 on 2017/3/22.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit

public struct AHFlatColor {
    let name:String
    let color:UIColor
}

open class SScheduleTheme: NSObject {
    
    // Flat Colors
    // Flat Colors
    open static let flatColors: [AHFlatColor] = [
        AHFlatColor(name:"Mint",color:UIColor(hexString: "#00C6AD")),
        AHFlatColor(name:"Green",color:UIColor(hexString: "#02D286")),
        AHFlatColor(name:"SkyBlue",color:UIColor(hexString: "#38A9E0")),
        AHFlatColor(name:"ForestGreen",color:UIColor(hexString: "#3E7054")),
        AHFlatColor(name:"NavyBlue",color:UIColor(hexString: "#425B71")),
        AHFlatColor(name:"Teal",color:UIColor(hexString: "#468294")),
        AHFlatColor(name:"Blue",color:UIColor(hexString: "#627AAF")),
        AHFlatColor(name:"Brown",color:UIColor(hexString: "#735744")),
        AHFlatColor(name:"Plum",color:UIColor(hexString: "#744670")),
        AHFlatColor(name:"Purple",color:UIColor(hexString: "#8974CD")),
        AHFlatColor(name:"Marnoon",color:UIColor(hexString: "#8E4238")),
        AHFlatColor(name:"Magenta",color:UIColor(hexString: "#AF70C0")),
        AHFlatColor(name:"Lime",color:UIColor(hexString: "#B2CF55")),
        AHFlatColor(name:"Coffee",color:UIColor(hexString: "#B49885")),
        AHFlatColor(name:"Orange",color:UIColor(hexString: "#EF9235")),
        AHFlatColor(name:"Red",color:UIColor(hexString: "#F3674E")),
        AHFlatColor(name:"WaterLemon",color:UIColor(hexString: "#F8888C")),
        AHFlatColor(name:"Pink",color:UIColor(hexString: "#FD94CE")),
    ]
    
    /// 分割线颜色
    open static var SeperatorColor = UIColor(hexString: "#dfdfdf")
    /// 空白部分背景色
    open static var BlankAreaColor = UIColor(hexString: "#f5f5f5")
    /// 内容部分背景色
    open static var WhiteBackColor = UIColor(hexString: "#ffffff")

}
