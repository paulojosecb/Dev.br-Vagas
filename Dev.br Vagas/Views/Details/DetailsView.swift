//
//  DetailsView.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import SwiftyMarkdown
import Down

class DetailsView: UIView {
    
    let issue: Issue
    
    var onSave: (([Label]?) -> Void)?
    
    var favoriteUseCase: FavoriteUseCase?
    
    var bodyViewHeight: CGFloat = 0
    var bodyViewWidth: CGFloat = 0
    
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .azul
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title1
        label.text = "Título da issue"
        label.numberOfLines = 2
        label.textColor = .white
        return label
    }()
    
    lazy var localLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .headline
        label.text = "em Rio de Janeiro/Remoto"
        label.textColor = .white
        return label
    }()
    
    lazy var cloudTag: CloudTag = {
        var tags: [String] = []
        
        guard let labels = self.issue.labels else {
            let cloudTag = CloudTag(frame: .zero, tags: [])
            cloudTag.translatesAutoresizingMaskIntoConstraints = false
            return cloudTag
        }
        
        for label in labels {
            tags.append(label.name ?? "")
        }

        let cloudTag = CloudTag(frame: .zero, tags: tags)
        cloudTag.translatesAutoresizingMaskIntoConstraints = false
        return cloudTag
    }()
        
    lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var createdLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .noteHeadline
        label.text = "Criado em \(issue.created_at ?? "")"
        label.textColor = .black50
        return label
    }()
    
    lazy var byLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .noteSubheadline
        label.text = "Por em eumesmo"
        label.textColor = .black50
        return label
    }()
    
    lazy var bodyView: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.sizeToFit()
        label.font = .body
        label.textColor = .black50
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
        self.backgroundColor = .background
        self.favoriteUseCase = FavoriteUseCase(gateway: UserDefaultManager())
        
        let title = issue.title
        let range = title?.range(of: "]")
        
        let titleString = title?[range!.upperBound...].trimmingCharacters(in: .whitespaces)
        let localString = title?[..<range!.lowerBound].replacingOccurrences(of: "[", with: "")
        
        titleLabel.text = titleString ?? ""
        localLabel.text = "em \(localString ?? "")"
        byLabel.text = "por \(issue.user?.login ?? "")"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "pt-BR")
        let date = formatter.date(from: issue.created_at!) ?? Date()
        let ptFormatter = DateFormatter()
        ptFormatter.dateFormat = "dd/MM/yyyy"
        let dateString = ptFormatter.string(from: date)
        createdLabel.text = "Postad em \(dateString)"
        
        bodyView.attributedText = try! Down(markdownString: issue.body ?? "").toAttributedString(.default, stylesheet: "* {font-family: Nunito-Regular; font-size: 1.2rem; color: rgba(0,0,0,0.8) } code, pre { font-family: Menlo }")
        
        bodyViewHeight = bodyView.intrinsicContentSize.height
                
        self.bodyView.heightAnchor.constraint(equalToConstant: bodyViewHeight + 400).isActive = true
        self.contentView.heightAnchor.constraint(equalToConstant: self.calculateContentSize() + 400).isActive = true
        
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func calculateContentSize() -> CGFloat {
        let contentSize = (16 + calculateLabelHeightFor(label: titleLabel, and: UIScreen.main.bounds.width) +
            16 + bodyViewHeight + 300  + 16 + 50)
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
            
            onSave(nil)
        }
    }
    
}

extension DetailsView: CodeView {
    func buildViewHierarchy() {
        
        
        backgroundView.addSubview(titleLabel)
        backgroundView.addSubview(localLabel)
        addSubview(backgroundView)

        contentView.addSubview(cloudTag)
        contentView.addSubview(bodyView)
        contentView.addSubview(avatarImageView)
        contentView.addSubview(createdLabel)
        contentView.addSubview(byLabel)
        contentView.addSubview(saveButton)
        contentView.addSubview(openButton)
        
        scrollView.addSubview(contentView)
        addSubview(scrollView)
    }
    
    func setupConstraints() {
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -8).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 180).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor, constant: 0).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: calculateLabelHeightFor(label: titleLabel, and: UIScreen.main.bounds.width)).isActive = true
        
        localLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        localLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        localLabel.heightAnchor.constraint(equalToConstant: localLabel.intrinsicContentSize.height).isActive = true
        localLabel.rightAnchor.constraint(equalTo: titleLabel.rightAnchor).isActive = true
        
        scrollView.topAnchor.constraint(equalTo: backgroundView.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        cloudTag.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 32).isActive = true
        cloudTag.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 8).isActive = true
        cloudTag.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor, constant: 8).isActive = true
        cloudTag.heightAnchor.constraint(equalToConstant: Tag.height).isActive = true
        
        avatarImageView.topAnchor.constraint(equalTo: cloudTag.bottomAnchor, constant: 24).isActive = true
        avatarImageView.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        avatarImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        avatarImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        createdLabel.centerYAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 16).isActive = true
        createdLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 8).isActive = true
        createdLabel.heightAnchor.constraint(equalToConstant: createdLabel.intrinsicContentSize.height).isActive = true
        createdLabel.widthAnchor.constraint(equalToConstant: createdLabel.intrinsicContentSize.width).isActive = true
        
        byLabel.topAnchor.constraint(equalTo: createdLabel.bottomAnchor, constant:  2).isActive = true
        byLabel.leftAnchor.constraint(equalTo: createdLabel.leftAnchor).isActive = true
        byLabel.heightAnchor.constraint(equalToConstant: byLabel.intrinsicContentSize.height).isActive = true
        byLabel.widthAnchor.constraint(equalToConstant: byLabel.intrinsicContentSize.width + 16).isActive = true
        
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
    }
    
    func setupAdditionalConfiguration() {
//        openButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOpenButton(_:))))
    }
    
    
}
