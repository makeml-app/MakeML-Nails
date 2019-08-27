//
//  UIColor.swift
//  Segmentation Nails
//
//  Created by Alexander Kartsev on 8/27/19.
//  Copyright © 2019 Alexey Korotkov. All rights reserved.
//

import Foundation

extension UIColor {
    static func uiColorFromHex(rgbValue: Int, alpha: CGFloat = 1) -> UIColor {
        
        // &  binary AND operator to zero out other color values
        // >>  bitwise right shift operator
        // Divide by 0xFF because UIColor takes CGFloats between 0.0 and 1.0
        
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    func switchBlueToRed() -> Int? {
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fBlue * 255.0) //using fBlue here for converted color
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fRed * 255.0) //using fRed here for converted color
            let iAlpha = Int(fAlpha * 255.0)
            
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            return nil
        }
    }
}
