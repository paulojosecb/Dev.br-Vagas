//
//  UIColor.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

extension UIColor {
    
    @nonobjc class var white: UIColor {
        return UIColor(white: 250.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var background: UIColor {
        return UIColor(white: 241.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black76: UIColor {
        return UIColor(white: 0.0, alpha: 0.76)
    }
    
    @nonobjc class var black40: UIColor {
        return UIColor(white: 0.0, alpha: 0.4)
    }
    
    @nonobjc class var azul70: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 87.0 / 255.0, blue: 229.0 / 255.0, alpha: 0.7)
    }
    
    @nonobjc class var veryLightBlue: UIColor {
        return UIColor(red: 229.0 / 255.0, green: 233.0 / 255.0, blue: 246.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var azul: UIColor {
        return UIColor(red: 40.0 / 255.0, green: 87.0 / 255.0, blue: 229.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var veryLightPink: UIColor {
        return UIColor(white: 189.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var black50: UIColor {
        return UIColor(white: 0.0, alpha: 0.5)
    }
    
}

extension UIColor {
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}
