//
//  CustomTabBar.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

enum ActiveTabBarItem {
    case left
    case right
}

class CustomTabBar: UIView, CustomView {
    
    static var height: CGFloat = 54
    
    var action1: (() -> Void)?
    var action2: (() -> Void)?
    
    var activeItem: ActiveTabBarItem = .left

    lazy var item1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.titleLabel?.font = .action
        button.setTitle("Todas", for: .normal)
        return button
    }()
    
    lazy var item2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.titleLabel?.font = .action
        button.setTitle("Favoritas", for: .normal)
        return button
    }()
    
    lazy var indicatorView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 2
        return view
    }()
 
    init(frame: CGRect, activeItem: ActiveTabBarItem) {
        self.activeItem = activeItem
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        self.setRoundedLayer(color: .azul, radius: 15, shadowOppacity: 0.8, shadowRadius: 5)
    }
    
    @objc func handleAction1(_ sender: UITapGestureRecognizer? = nil) {
        guard let action = self.action1 else { return }
        action()
    }
    
    @objc func handleAction2(_ sender: UITapGestureRecognizer? = nil) {
        guard let action = self.action2 else { return }
        action()
    }
}

extension CustomTabBar: CodeView {
    func buildViewHierarchy() {
        addSubview(item1)
        addSubview(item2)
        addSubview(indicatorView)
    }
    
    func setupConstraints() {
        item1.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        item1.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        item1.heightAnchor.constraint(equalToConstant: item1.intrinsicContentSize.height).isActive = true
        item1.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        item2.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        item2.leftAnchor.constraint(equalTo: item1.rightAnchor).isActive = true
        item2.heightAnchor.constraint(equalToConstant: item1.intrinsicContentSize.height).isActive = true
        item2.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5).isActive = true
        
        let itemToUseAsReference = activeItem == .left ? item1 : item2
        
        indicatorView.heightAnchor.constraint(equalToConstant: 2).isActive = true
        indicatorView.widthAnchor.constraint(equalToConstant: itemToUseAsReference.titleLabel?.intrinsicContentSize.width ?? 0).isActive = true
        indicatorView.topAnchor.constraint(equalTo: item1.bottomAnchor, constant: 0).isActive = true
        indicatorView.centerXAnchor.constraint(equalTo: itemToUseAsReference.centerXAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        item1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAction1(_:))))
        item2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAction2(_:))))
    }
}
