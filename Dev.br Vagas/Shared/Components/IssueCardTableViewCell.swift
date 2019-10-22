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
            let range = title?.range(of: "]")
            let titleString = title?[range!.upperBound...].trimmingCharacters(in: .whitespaces)
            let localString = title?[..<range!.lowerBound].replacingOccurrences(of: "[", with: "")
            
            titleLabel.text = titleString
            localLabel.text = "\(localString ?? "")"
        }
    }
    
    var state: String? {
        didSet {
            stateLabel.text = state == "open" ? "Aberta" : "Fechada"
            stateLabel.backgroundColor = state == "open" ? .systemGreen : .systemRed
            stateLabel.textColor = .white
        }
    }
    
    var createdAt: String? {
        didSet {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            formatter.locale = Locale(identifier: "pt-BR")
            let date = formatter.date(from: createdAt!) ?? Date()
            let ptFormatter = DateFormatter()
            ptFormatter.dateFormat = "dd/MM/yyyy"
            let dateString = ptFormatter.string(from: date)
            createdAtLabel.text = dateString
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
        label.text = "Título da Issue um tamanho suficiente para ser de duas linhas mas acho que da pra passar mais um pouco"
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var createdAtLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "22/10/2019"
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    lazy var localLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.text = "Rio de Janeiro/Remoto"
        label.textColor = .white
        return label
    }()
        
    lazy var stateLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Aberta"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 2
        return label
    }()
    
    override func draw(_ rect: CGRect) {
        cardView.setRoundedLayer(color: .darkBackground, radius: 10, shadowOppacity: 0.5, shadowRadius: 10)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .lightBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateLabelHeightFor(label: UILabel, and width: CGFloat) -> CGFloat {
        guard let labelWidth = label.attributedText?.size().width,
            let labelHeight = label.attributedText?.size().height else { return 0 }
        
        let numberOfLines = ceil(labelWidth / width)
        let height = labelHeight * numberOfLines
        return height + 10
    }
    
}

extension IssueCardTableViewCell: CodeView {
    func buildViewHierarchy() {
        contentView.addSubview(cardView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(localLabel)
        contentView.addSubview(createdAtLabel)
    }
    
    func setupConstraints() {
        cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8).isActive = true
        cardView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 46).isActive = true
        
        localLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12).isActive = true
        localLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        localLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.75).isActive = true
        localLabel.heightAnchor.constraint(equalToConstant: localLabel.intrinsicContentSize.height).isActive = true
        
        createdAtLabel.centerYAnchor.constraint(equalTo: localLabel.centerYAnchor).isActive = true
        createdAtLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor).isActive = true
        createdAtLabel.heightAnchor.constraint(equalToConstant: createdAtLabel.intrinsicContentSize.height).isActive = true
        createdAtLabel.widthAnchor.constraint(equalToConstant: createdAtLabel.intrinsicContentSize.width).isActive = true
        
//        stateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
//        stateLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor).isActive = true
//        stateLabel.widthAnchor.constraint(equalToConstant: stateLabel.intrinsicContentSize.width + 4).isActive = true
//        stateLabel.heightAnchor.constraint(equalToConstant: stateLabel.intrinsicContentSize.height).isActive = true
    }

    func setupAdditionalConfiguration() {
        
    }
    
    
}
