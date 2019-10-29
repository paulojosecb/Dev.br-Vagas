//
//  UINavigationController.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
       if #available(iOS 13.0, *) {
           return .darkContent
       } else {
           return .default
       }
   }
}
