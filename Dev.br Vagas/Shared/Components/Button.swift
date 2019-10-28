//
//  Button.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

enum ButtonType {
    case ghost
    case normal
    case destructive
}

class Button: UIView {
    
    static var height: CGFloat = 48.0
    
    var type: ButtonType
    var title: String
    let action: (() -> Void)?
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .callout)
        label.text = self.title
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect, type: ButtonType, title: String, action: (() -> Void)? = nil) {
        self.type = type
        self.title = title
        self.action = action
        super.init(frame: frame)
        setupView()
        setType(type)
    }
    
    override func layoutSubviews() {
        addShadow()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        guard let action = self.action else { return }
        action()
        
        let feedbackGenerator = UISelectionFeedbackGenerator()
        feedbackGenerator.selectionChanged()
    }
    
    func addShadow() {
        if (type == .normal) {
            let shadowLayer = CAShapeLayer()
            shadowLayer.masksToBounds = false
            
            shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 5).cgPath
            shadowLayer.fillColor = UIColor.background.cgColor
            shadowLayer.shadowColor = UIColor.background.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 5.0)
            shadowLayer.shadowOpacity = 0.5
            shadowLayer.shadowRadius = 3
            
            self.layer.insertSublayer(shadowLayer, at: 0)
        }
    }
    
    func setTitle(_ title: String) {
        self.title = title
        self.label.text = title
    }
    
    func setType(_ type: ButtonType) {
        self.type = type
        
        UIView.animate(withDuration: 0.3) {
            switch type {
            case .ghost:
                self.backgroundView.backgroundColor = .none
                self.backgroundView.layer.borderColor = UIColor.white.cgColor
                self.backgroundView.layer.borderWidth = 1
                
                self.label.textColor = .white
            case .normal:
                self.backgroundView.backgroundColor = .background
                self.backgroundView.layer.borderColor = UIColor.background.cgColor
                self.label.textColor = .white
            case .destructive:
                self.label.textColor = .white
            }
        }
        
    }
    
}

extension Button: CodeView {
    func buildViewHierarchy() {
        addSubview(backgroundView)
        addSubview(label)
    }
    
    func setupConstraints() {
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:))))
    }
    
    
}
