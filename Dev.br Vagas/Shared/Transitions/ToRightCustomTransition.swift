//
//  ToRightCustomTransition.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class ToRightCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? HomeViewController,
            let fromView = transitionContext.view(forKey: .from),
            let toVC = transitionContext.viewController(forKey: .to) as? HomeViewController,
            let toView = transitionContext.view(forKey: .to) else {
                return
        }
        
        UIView.animate(withDuration: 0.3) {
            
        }
    }
}
