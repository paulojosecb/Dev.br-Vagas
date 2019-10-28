//
//  Tag.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class Tag: UIView {
    
    let name: String
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.text = self.name
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .azul70
        label.font = .footnote
        return label
    }()
    
    init(frame: CGRect, name: String) {
        self.name = name
        super.init(frame: frame)
        setupView()
        backgroundColor = .veryLightBlue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension Tag: CodeView {
    func buildViewHierarchy() {
        addSubview(label)
    }
    
    func setupConstraints() {
        self.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width + 4).isActive = true
        self.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height + 2).isActive = true
        
        label.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalToConstant: label.intrinsicContentSize.width).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height).isActive = true    }
    
    func setupAdditionalConfiguration() {
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 2
    }
}
