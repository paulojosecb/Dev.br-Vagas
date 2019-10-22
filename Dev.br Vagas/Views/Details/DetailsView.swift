//
//  DetailsView.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import SwiftyMarkdown

class DetailsView: UIView {
    
    let issue: Issue
    
    var onSave: (() -> Void)?
    
    var favoriteUseCase: FavoriteUseCase?
    
    var bodyViewHeight: CGFloat = 0
    var bodyViewWidth: CGFloat = 0
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title1)
        label.text = "Título da issue"
        label.numberOfLines = 3
        label.textColor = .white
        return label
    }()
    
    lazy var stateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .title3)
        label.backgroundColor = issue.state == "open" ? .systemGreen : .systemRed
        label.textColor = .white
        return label
    }()
    
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var createdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .preferredFont(forTextStyle: .footnote)
        label.text = "Criado em 16/10/2019"
        label.textColor = .white
        return label
    }()
    
    lazy var bodyView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .white
        return label
    }()
    
    lazy var saveButton: Button = {
        let button = Button(frame: .zero, type: .normal, title: "Action", action: handleSaveButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        self.favoriteUseCase?.isSaved(issue: self.issue, completion: { (result) in
            switch result {
            case let .saved(s):
                button.setTitle(s ? "Remover" : "Salvar")
                button.setType(s ? .destructive : .normal)
            default:
                button.setTitle("Salvar")
            }
        })
        
        return button
    }()
    
    lazy var openButton: Button = {
        let button = Button(frame: .zero, type: .ghost, title: "Abir no navegador", action: handleOpenButton)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    override func draw(_ rect: CGRect) {
        avatarImageView.layer.masksToBounds = true
        avatarImageView.layer.cornerRadius = avatarImageView.frame.width / 2
    }
    
    init(frame: CGRect, issue: Issue) {
        self.issue = issue
        super.init(frame: frame)
        self.backgroundColor = .lightBackground
        self.favoriteUseCase = FavoriteUseCase(gateway: UserDefaultManager())
        
        titleLabel.text = issue.title
        stateLabel.text = issue.state
        
        let md = SwiftyMarkdown(string: issue.body ?? "")
        md.body.fontName = "Avenir-Regular"
        md.body.color = .white
        md.h1.fontName =  "Avenir-Bold"
        md.h2.fontName =  "Avenir-Bold"
        md.h3.fontName =  "Avenir-Bold"
        md.h4.fontName =  "Avenir-Bold"
        md.h5.fontName =  "Avenir-Bold"
        
        md.h1.color = .white
        md.h2.color = .white
        md.h3.color = .white
        md.h4.color = .white
        md.h5.color = .white


        bodyView.attributedText = md.attributedString()
        
        bodyViewHeight = bodyView.intrinsicContentSize.height
                
        self.bodyView.heightAnchor.constraint(equalToConstant: bodyViewHeight).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: self.calculateContentSize()).isActive = true
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateContentSize() -> CGFloat {
        let contentSize = (16 + calculateLabelHeightFor(label: titleLabel, and: UIScreen.main.bounds.width) +
            16 + bodyViewHeight  + 16 + stateLabel.intrinsicContentSize.height + 16 + 50)
        return contentSize
    }
    
    func calculateLabelHeightFor(label: UILabel, and width: CGFloat) -> CGFloat {
        guard let labelWidth = label.attributedText?.size().width,
            let labelHeight = label.attributedText?.size().height else { return 0 }
        
        let numberOfLines = ceil(labelWidth / width)
        let height = labelHeight * numberOfLines
        return height + 10
    }
    
    @objc func handleOpenButton() {
        guard let issueUrl = issue.html_url, let url = URL(string: issueUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    @objc func handleSaveButton() {
        guard let number = issue.number, let useCase = favoriteUseCase else { return }
        useCase.toggleFavorite(issue: self.issue) { (result) in
            switch result {
            case .added:
                saveButton.setTitle("Remover")
                saveButton.setType(.destructive)
            case .removed:
                saveButton.setTitle("Salvar")
                saveButton.setType(.normal)
            default:
                print()
            }
            
            guard let onSave = onSave else {
                return
            }
            
            onSave()
        }
    }
    
}

extension DetailsView: CodeView {
    func buildViewHierarchy() {
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(bodyView)
        contentView.addSubview(stateLabel)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(createdLabel)
        contentView.addSubview(saveButton)
        contentView.addSubview(openButton)
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        scrollView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 8).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: calculateLabelHeightFor(label: titleLabel, and: UIScreen.main.bounds.width) + 30).isActive = true
        
        stateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16).isActive = true
        stateLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        stateLabel.heightAnchor.constraint(equalToConstant: stateLabel.intrinsicContentSize.height).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: stateLabel.bottomAnchor, constant: 16).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        createdLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor).isActive = true
        createdLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8).isActive = true
        createdLabel.heightAnchor.constraint(equalToConstant: createdLabel.intrinsicContentSize.height).isActive = true
        createdLabel.widthAnchor.constraint(equalToConstant: createdLabel.intrinsicContentSize.width).isActive = true
        
        openButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 32).isActive = true
        openButton.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        openButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.45).isActive = true
        openButton.heightAnchor.constraint(equalToConstant: Button.height).isActive = true
        
        saveButton.topAnchor.constraint(equalTo: openButton.topAnchor).isActive = true
        saveButton.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        saveButton.widthAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.widthAnchor, multiplier: 0.45).isActive = true
        saveButton.heightAnchor.constraint(equalToConstant: Button.height).isActive = true
        
        bodyView.topAnchor.constraint(equalTo: openButton.bottomAnchor, constant: 32).isActive = true
        bodyView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        bodyView.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
//        bodyView?.heightAnchor.constraint(equalToConstant: 500).isActive = true
    }
    
    func setupAdditionalConfiguration() {
//        openButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenButton(_:))))
    }
    
    
}
