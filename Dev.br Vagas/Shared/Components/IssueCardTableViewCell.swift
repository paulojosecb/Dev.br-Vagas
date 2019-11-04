//
//  IssueCardTableViewCell.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class IssueCardTableViewCell: UITableViewCell {
    
    static var height: CGFloat = 114
    
    var favoriteUseCase: FavoriteUseCase?
    
    var issue: Issue? {
        didSet {
            favoriteUseCase?.isSaved(issue: issue!, completion: { (result) in
                switch result {
                case let .saved(isSaved):
                    self.hearthButton.filled = isSaved
                default:
                    self.hearthButton.filled = false
                }
            })
        }
    }
    
    var title: String? {
        didSet {
            let range = title?.range(of: "]")
            let titleString = title?[range!.upperBound...].trimmingCharacters(in: .whitespaces)
            let localString = title?[..<range!.lowerBound].replacingOccurrences(of: "[", with: "")
            
            titleLabel.text = titleString
            localLabel.text = "\(localString ?? "")"
        }
    }
    
    var tags: [String]? {
        didSet {
            cloudTag.tags = tags
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
        label.font = .title2
        label.text = "Título da Issue um tamanho suficiente para ser de duas linhas mas acho que da pra passar mais um pouco"
        label.numberOfLines = 0
        label.textColor = .black76
        return label
    }()
    
    lazy var localLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .subheadline
        label.text = "Rio de Janeiro/Remoto"
        label.textColor = .black40
        return label
    }()
    
    lazy var cloudTag: CloudTag = {
        let view = CloudTag(frame: .zero, tags: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
            
    lazy var hearthButton: HeathButton = {
        let view = HeathButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleFavoriteGesture(_:))))
        return view
    }()
    
    override func draw(_ rect: CGRect) {
        cardView.setRoundedLayer(color: .white, radius: 10, shadowOppacity: 0.5, shadowRadius: 10)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .background
        setupView()
        
        favoriteUseCase = FavoriteUseCase(gateway: UserDefaultManager())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleFavoriteGesture(_ sender: UITapGestureRecognizer? = nil) {
        guard let issue = issue else { return }
        favoriteUseCase?.toggleFavorite(issue: issue, completion: { (result) in
            switch result {
            case .failure(_):
                print("Error")
            default:
                self.hearthButton.filled = !self.hearthButton.filled
                let feedbackGenerator = UISelectionFeedbackGenerator()
                feedbackGenerator.selectionChanged()
            }
        })
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
        contentView.addSubview(cloudTag)
        contentView.addSubview(hearthButton)
    }
    
    func setupConstraints() {
        cardView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        cardView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        cardView.rightAnchor.constraint(equalTo: contentView.layoutMarginsGuide.rightAnchor).isActive = true
        cardView.heightAnchor.constraint(equalToConstant: 93).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 8).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: cardView.layoutMarginsGuide.leftAnchor).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor, constant: -8).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        
        localLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 0).isActive = true
        localLabel.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        localLabel.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.75).isActive = true
        localLabel.heightAnchor.constraint(equalToConstant: localLabel.intrinsicContentSize.height).isActive = true
        
        cloudTag.topAnchor.constraint(equalTo: localLabel.bottomAnchor, constant: 9).isActive = true
        cloudTag.leftAnchor.constraint(equalTo: titleLabel.leftAnchor).isActive = true
        cloudTag.heightAnchor.constraint(equalToConstant: 19).isActive = true
        cloudTag.rightAnchor.constraint(equalTo: hearthButton.leftAnchor, constant: -8).isActive = true
    
        hearthButton.widthAnchor.constraint(equalToConstant: 26).isActive = true
        hearthButton.heightAnchor.constraint(equalToConstant: 24).isActive = true
        hearthButton.rightAnchor.constraint(equalTo: cardView.layoutMarginsGuide.rightAnchor, constant: -4).isActive = true
        hearthButton.centerYAnchor.constraint(equalTo: cloudTag.centerYAnchor).isActive = true
    }

    func setupAdditionalConfiguration() {
        
    }
    
    
}
