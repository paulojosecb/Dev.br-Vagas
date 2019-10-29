//
//  ToLeftCustomTransition.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class ToLeftCustomTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from) as? HomeViewController,
            let fromView = transitionContext.view(forKey: .from) as? HomeView,
            let toVC = transitionContext.viewController(forKey: .to) as? HomeViewController,
            let toView = transitionContext.view(forKey: .to) as? HomeView else {
                return
        }
        
        toView.frame = CGRect(x: UIScreen.main.bounds.width,
                              y: 0,
                              width: toView.frame.width,
                              height: toView.frame.height)
        
//        UIView.animate(withDuration: 0.3, animations: {
//            fromView.frame = CGRect(x: 0 - UIScreen.main.bounds.width,
//                                    y: 0,
//                                    width: fromView.frame.width,
//                                    height: fromView.frame.height)
//            
//            toView.frame = CGRect(x: 0,
//                                  y: 0,
//                                  width: toView.frame.width,
//                                  height: toView.frame.height)
//        }) { (b) in
//            transitionContext.completeTransition(true)
//        }
    }
}
