//
//  HearthButton.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class HeathButton: UIButton {
    
    var filled: Bool = true {
        didSet {
            drawShape()
        }
    }
    
    var strokeColor: UIColor = UIColor.azul70
    
    override func draw(_ rect: CGRect) {
       drawShape()
    }
    
    func drawShape() {
        UIView.animate(withDuration: 0.3) {
            self.layer.sublayers?[0].removeFromSuperlayer()
            
            let layer = CAShapeLayer()
            layer.path = UIBezierPath(heartIn: self.bounds).cgPath
            layer.strokeColor = UIColor.azul70.cgColor
            
            layer.fillColor = self.filled ? UIColor.azul.cgColor : nil
            self.layer.addSublayer(layer)
        }
    }
}
