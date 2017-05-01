//
//  Extension_UIColor.swift
//  SScheduleView_Example
//
//  Created by 黄帅 on 2017/4/28.
//  Copyright © 2017年 huangshuai. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        self.init(hexString: hexString, alpha: 1.0)
    }
    
    convenience init(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 1))
        }
        
        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
            
            // Deal with 3 character Hex strings
            if hex.characters.count == 3 {
                let redHex   = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 1))
                let greenHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 1)..<hex.characters.index(hex.startIndex, offsetBy: 2))
                //                    Range<String.Index>(start: hex.startIndex.advancedBy(1), end: hex.startIndex.advancedBy(2)))
                let blueHex  = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
            let greenHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 2)..<hex.characters.index(hex.startIndex, offsetBy: 4))
            //                Range<String.Index>(start: hex.startIndex.advancedBy(2), end: hex.startIndex.advancedBy(4)))
            let blueHex = hex.substring(with: hex.characters.index(hex.startIndex, offsetBy: 4)..<hex.characters.index(hex.startIndex, offsetBy: 6))
            //                Range<String.Index>(start: hex.startIndex.advancedBy(4), end: hex.startIndex.advancedBy(6)))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init(red: CGFloat(0) / 255.0, green: CGFloat(0) / 255.0, blue: CGFloat(0) / 255.0, alpha: CGFloat(0.5))
        }
    }
}
