//
//  HomeView.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class HomeView: UIView {
    
    weak var parentVC: HomeViewController?
    
    var isLoading: Bool = false {
        didSet {
            tableView.isHidden = isLoading ? true : false
            emptyLabel.isHidden = isLoading ? true : isEmpty ? false : true
            emptyImage.isHidden = isLoading ? true : isEmpty ? false : true
            activityIndicator.isHidden = isLoading ? false : true
            
            if (isLoading) {
                activityIndicator.startAnimating()
            } else {
                activityIndicator.stopAnimating()
            }
        }
    }
    
    var isEmpty: Bool = false {
        didSet {
            tableView.isHidden = isEmpty ? true : false
            emptyLabel.isHidden = isEmpty ? false : true
            emptyImage.isHidden = isEmpty ? false : true

        }
    }
    
    lazy var activityIndicator: NVActivityIndicatorView = {
        let view = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 48, height: 48), type: .lineScale, color: .azul, padding: nil)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var emptyImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "empty") ?? UIImage()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var emptyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .title3
        label.textColor = .azul70
        label.text =  self.parentVC?.mode == .all ? "Não foi encontrado resultados.\nAjuste os filtros e tente novamente" : "Não há nenhuma vaga salva"
        label.numberOfLines = 3
        label.textAlignment = .center
        label.isHidden = true
        return label
    }()
    
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
        self.backgroundColor = .background
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension HomeView: CodeView {
    func buildViewHierarchy() {
        addSubview(tableView)
        addSubview(activityIndicator)
        addSubview(emptyLabel)
        addSubview(emptyImage)
    }
    
    func setupConstraints() {
        tableView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        
        emptyImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        emptyImage.bottomAnchor.constraint(equalTo: emptyLabel.topAnchor, constant: -4).isActive = true
        emptyImage.widthAnchor.constraint(equalToConstant: 96).isActive = true
        emptyImage.heightAnchor.constraint(equalToConstant: 96).isActive = true
        
        emptyLabel.centerXAnchor.constraint(equalTo: tableView.centerXAnchor).isActive = true
        emptyLabel.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: 32).isActive = true
        emptyLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8).isActive = true
        emptyLabel.heightAnchor.constraint(equalToConstant: emptyLabel.intrinsicContentSize.height * 2).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 48).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    func setupAdditionalConfiguration() {
        
    }
    
}
