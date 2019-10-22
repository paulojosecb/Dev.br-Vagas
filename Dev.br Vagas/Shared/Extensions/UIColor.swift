//
//  UIColor.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

extension UIColor {
    @nonobjc class var primary: UIColor {
        return UIColor(red: 74 / 255, green: 77 / 255, blue: 173 / 255, alpha: 1)
    }
    
    @nonobjc class var background: UIColor {
        return UIColor(red: 35 / 255, green: 40 / 255, blue: 59 / 255, alpha: 1)
    }
    
    @nonobjc class var lightBackground: UIColor {
        return UIColor(red: 59 / 255, green: 66 / 255, blue: 87 / 255, alpha: 1)
    }
    
    @nonobjc class var darkBackground: UIColor {
        return UIColor(red: 37 / 255, green: 43 / 255, blue: 81 / 255, alpha: 1)
    }
    
    @nonobjc class var destructive: UIColor {
      return UIColor(red: 223.0 / 255.0, green: 58.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
    
    @nonobjc class var customGreen: UIColor {
      return UIColor(red: 94 / 255.0, green: 86 / 255.0, blue: 92 / 255.0, alpha: 1.0)
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
