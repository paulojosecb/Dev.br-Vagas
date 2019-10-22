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
    
    @nonobjc class var destructive: UIColor {
      return UIColor(red: 223.0 / 255.0, green: 58.0 / 255.0, blue: 80.0 / 255.0, alpha: 1.0)
    }
}
