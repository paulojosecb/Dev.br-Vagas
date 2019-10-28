//
//  HomeView.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

class HomeView: UIView {
    
    weak var parentVC: HomeViewController?
    
    lazy var refreshControl: UIRefreshControl = {
        let control = UIRefreshControl()
        control.tintColor = .white
        return control
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self.parentVC
        tableView.dataSource = self.parentVC
        tableView.register(IssueCardTableViewCell.self, forCellReuseIdentifier: String(describing: IssueCardTableViewCell.self))
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        if #available(iOS 10.0, *) {
            tableView.refreshControl = self.refreshControl
        } else {
          tableView.addSubview(refreshControl)
        }
        return tableView
    }()
    
    init(frame: CGRect, parentVC: HomeViewController) {
        super.init(frame: frame)
        self.parentVC = parentVC
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeView: CodeView {
    func buildViewHierarchy() {
        addSubview(tableView)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
}
