//
//  TransitionCoordinator.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 29/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class TransitionCoordinator: NSObject, UINavigationControllerDelegate {
    
    static var shared = TransitionCoordinator()
    
    func navigationController(_ navigationController: UINavigationController,
                              animationControllerFor operation: UINavigationController.Operation,
                              from fromVC: UIViewController,
                              to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let fromVC = fromVC as? HomeViewController else { return nil }
        
        if (fromVC.mode == .all) {
            return nil
        } else {
            return nil //ToRightCustomTransition()
        }
    }
}
