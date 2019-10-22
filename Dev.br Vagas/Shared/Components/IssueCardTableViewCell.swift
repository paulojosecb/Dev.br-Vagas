//
//  IssueCardTableViewCell.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class IssueCardTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 120
    
    var title: String? {
        didSet {
            titleLabel.text = title
        }
    }
    
    var state: String? {
        didSet {
            stateLabel.text = state
            stateLabel.backgroundColor = state == "open" ? .systemGreen : .systemRed
            stateLabel.textColor = .white
        }
    }
    
    lazy var cardView: CardView = {
        let view = CardView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .medium)
        label.text = "Título da Issue um tamanho suficiente para ser de duas linhas aaaaaaa"
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var stateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Estado"
        label.textAlignment = .center
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        cardView.setRoundedLayer(color: UIColor(white: 1, alpha: 0.2), radius: 10, shadowOppacity: 0.5, shadowRadius: 10)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension IssueCardTableViewCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(cardView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(stateLabel)
    }
    
    func setupConstraints() {
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cardView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        stateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: cardView.leftAnchor, constant: 8).isActive = true
        stateLabel.widthAnchor.constraint(equalToConstant: stateLabel.intrinsicContentSize.width).isActive = true
        stateLabel.heightAnchor.constraint(equalToConstant: stateLabel.intrinsicContentSize.height).isActive = true
    }

    func setupAdditionalConfiguration() {
        
    }
    
    
}
