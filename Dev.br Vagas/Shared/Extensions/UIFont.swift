//
//  UIFont.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

extension UIFont {
    
    class var title1: UIFont {
        return UIFont(name: "Nunito-Bold", size: 32.0)!
    }
    
    class var title2: UIFont {
        return UIFont(name: "Nunito-ExtraBold", size: 16.0)!
    }
    
    class var headline: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 20.0)!
    }
    
    class var action: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 18.0)!
    }
    
    class var title3: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 18.0)!
    }
    
    class var body: UIFont {
        return UIFont(name: "Nunito-Regular", size: 18.0)!
    }
    
    class var noteHeadline: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 16.0)!
    }
    
    class var noteSubheadline: UIFont {
        return UIFont(name: "Nunito-Regular", size: 16.0)!
    }
    
    class var footnote: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 14.0)!
    }
    
    class var subheadline: UIFont {
        return UIFont(name: "Nunito-SemiBold", size: 14.0)!
    }
    
    class var tabBarItem: UIFont {
        return UIFont(name: "Nunito-Bold", size: 14.0)!
    }
    
}
