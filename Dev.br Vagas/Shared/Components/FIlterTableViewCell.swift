//
//  FIlterTableViewCell.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 28/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 64
    
    var cellSelected: Bool = false {
        didSet {
            checkMarkView.isHidden = cellSelected ? false : true
        }
    }
    
    lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.textColor = .black50
        label.text = "Filtro"
        return label
    }()
    
    lazy var checkMarkView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "tick") ?? UIImage()
        return view
    }()
    
    
    override func draw(_ rect: CGRect) {
        cardView.setRoundedLayer(color: .white, radius: 5, shadowOppacity: 0.5, shadowRadius: 5)
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FilterTableViewCell: CodeView {
    func buildViewHierarchy() {
        addSubview(cardView)
        addSubview(label)
        addSubview(checkMarkView)
    }
    
    func setupConstraints() {
        cardView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        label.centerYAnchor.constraint(equalTo: cardView.centerYAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor).isActive = true
        label.heightAnchor.constraint(equalToConstant: label.intrinsicContentSize.height).isActive = true
        label.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.6).isActive = true
        
        checkMarkView.centerYAnchor.constraint(equalTo: label.centerYAnchor).isActive = true
        checkMarkView.widthAnchor.constraint(equalToConstant: 31).isActive = true
        checkMarkView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        checkMarkView.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
    
}
