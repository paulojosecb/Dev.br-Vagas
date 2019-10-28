//
//  FilterView.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 25/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class FilterView: UIView {
    
    var labels: [Label]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var savedLabels: [Label]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    var addAction: ((Label) -> Void)?
    var removeAction: ((Label) -> Void)?
    
    var handleClose: (() -> Void)
    
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
        label.textColor = .white
        label.text = "Filtrar"
        return label
    }()
    
    lazy var closeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "close") ?? UIImage()
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .background
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    init(frame: CGRect, handleClose: @escaping (() -> Void)) {
        self.handleClose = handleClose
        super.init(frame: frame)
        self.backgroundColor = .background
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handleCloseTapGesture(_ sender: UITapGestureRecognizer? = nil) {
        self.handleClose()
    }
    
}

extension FilterView: CodeView {
    func buildViewHierarchy() {
        addSubview(backgroundView)
        addSubview(titleLabel)
        addSubview(closeImageView)
        addSubview(tableView)
    }
    
    func setupConstraints() {
        backgroundView.topAnchor.constraint(equalTo: self.topAnchor, constant: -8).isActive = true
        backgroundView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        backgroundView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        backgroundView.heightAnchor.constraint(equalToConstant: 83).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 0).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.width).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.intrinsicContentSize.height).isActive = true
        
        closeImageView.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        closeImageView.widthAnchor.constraint(equalToConstant: 18).isActive = true
        closeImageView.heightAnchor.constraint(equalToConstant: 18).isActive = true
        closeImageView.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor).isActive = true
        
        tableView.topAnchor.constraint(equalTo: self.backgroundView.bottomAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        closeImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCloseTapGesture(_:))))
    }
}

extension FilterView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return labels?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let labels = self.labels, let savedLabels = savedLabels else { return UITableViewCell() }
        let cell = UITableViewCell()
        cell.textLabel?.text = labels[indexPath.row].name
        
        cell.backgroundColor = .background
        cell.textLabel?.textColor = .white
//        cell.selectionStyle = .none
        cell.accessoryType = labels[indexPath.row].isOnCollection(savedLabels) ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let savedLabels = savedLabels,
            let labels = labels,
            let addAction = addAction else { return }
            
        if (!labels[indexPath.row].isOnCollection(savedLabels)) {
            addAction(labels[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        guard let savedLabels = savedLabels,
            let labels = labels,
            let removeAction = removeAction else { return }
        
        if (labels[indexPath.row].isOnCollection(savedLabels)) {
            removeAction(labels[indexPath.row])
        } 
    }
}
