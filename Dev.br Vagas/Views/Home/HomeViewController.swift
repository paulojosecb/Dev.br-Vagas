//
//  ViewController.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit
import Alamofire

class HomeViewController: UIViewController {
    
    var contentView: HomeView?
    
    var issueUseCase: IssueUseCase?
    
    var issues: [Issue] = [] {
        didSet {
            guard let contentView = contentView else { return }
            contentView.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Issues"
        
        self.contentView = HomeView(frame: self.view.bounds, parentVC: self)
        self.view = contentView
        
        issueUseCase = IssueUseCase(gateway: ApiManager(), presenter: self)
        issueUseCase?.fetchAllIssues()
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
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

