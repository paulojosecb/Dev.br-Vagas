//
//  ViewController.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import Alamofire

enum HomeMode {
    case all
    case favorites
}

class HomeViewController: UIViewController {
    
    var contentView: HomeView?
    
    var issueUseCase: IssueUseCase?
    let mode: HomeMode
    
    var issues: [Issue] = [] {
        didSet {
            guard let contentView = contentView else { return }
            contentView.tableView.reloadData()
        }
    }
    
    init(mode: HomeMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = mode == .all ? "Todas vagas" : "Favoritas"
                
        if (mode == .all) {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Favoritos", style: .plain, target: self, action: #selector(presentFavorites))
        }

        self.contentView = HomeView(frame: self.view.bounds, parentVC: self)
        self.view = contentView
        
        issueUseCase = IssueUseCase(gateway: mode == .all ? ApiManager() : UserDefaultManager(), presenter: self)
        issueUseCase?.fetchIssues()
    }
        
    func presentErrorAlert() {
        let alertController = UIAlertController(title: "Ocorreu um erro",
                                                message: "Houve um erro enquanto processávamos sua requisição",
                                                preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
           alertController.dismiss(animated: true, completion: nil)
        }

        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func presentFavorites() {
        let vc = HomeViewController(mode: .favorites)
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

extension HomeViewController: IssuePresenter {
    
    func presentImage(result: ImageFetchResult<UIImage>) {
        
    }

    func presentResponse(result: IssueUseCaseResult<[Issue]>) {
        switch result {
        case let .sucess(issues):
            self.issues = issues
        case .failure(_):
            presentErrorAlert()
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueCardTableViewCell.self)) as? IssueCardTableViewCell else { return UITableViewCell() }
        
        cell.title = issues[indexPath.row].title
        cell.state = issues[indexPath.row].state
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IssueCardTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewControlller(issue: issues[indexPath.row])
        if (mode == .favorites) {
            vc.onSave = issueUseCase?.fetchIssues
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

