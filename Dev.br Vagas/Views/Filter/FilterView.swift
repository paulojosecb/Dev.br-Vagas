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
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightBackground
        tableView.allowsMultipleSelection = true
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .lightBackground
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FilterView: CodeView {
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.topAnchor, constant: 16).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
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
        
        cell.backgroundColor = .lightBackground
        cell.textLabel?.textColor = .white
        cell.selectionStyle = .none
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
