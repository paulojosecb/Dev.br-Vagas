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
    var selectedLabelsUseCase: LabelUseCase?
    
    let mode: HomeMode
    
    var issues: [Issue] = [] {
        didSet {
            guard let contentView = contentView else { return }
            self.contentView?.refreshControl.endRefreshing()
            contentView.tableView.reloadData()
        }
    }
    
    var filteredIssues: [Issue] = [] {
        didSet {
            guard let contentView = contentView else { return }
            contentView.tableView.reloadData()
        }
    }
    
    lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: nil)
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.tintColor = .white
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]

        return controller
    }()
    
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
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
            let rightBarButton = UIBarButtonItem(title: "Favoritos", style: .plain, target: self, action: #selector(presentFavorites))
            rightBarButton.setTitleTextAttributes([.font: UIFont.action], for: UIControl.State.normal)
            
            let leftBarButton = UIBarButtonItem(title: "Filtros", style: .plain, target: self, action: #selector(presentFilter))
            leftBarButton.setTitleTextAttributes([ .font: UIFont.action], for: UIControl.State.normal)

            self.navigationItem.rightBarButtonItem = rightBarButton
            self.navigationItem.leftBarButtonItem = leftBarButton
        }

        self.contentView = HomeView(frame: self.view.bounds, parentVC: self)
        self.contentView?.refreshControl.addTarget(self, action: #selector(fetchIsseus), for: .valueChanged)
        self.view = contentView
        
        issueUseCase = IssueUseCase(gateway: mode == .all ? ApiManager() : UserDefaultManager(), presenter: self)
        selectedLabelsUseCase = LabelUseCase(gateway: UserDefaultManager())
        
        self.navigationItem.searchController = self.searchController
        definesPresentationContext = true
    }
    
    @objc func fetchIsseus() {
        guard let issueUseCase = issueUseCase,
            let selectedLabelsUseCase = selectedLabelsUseCase else { return }
        
        selectedLabelsUseCase.fetchLabels { (result) in
            switch result {
            case let .sucess(selectedLabels):
                issueUseCase.fetchIssues(with: selectedLabels)
            case .failure(_):
                self.presentErrorAlert()
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchIsseus()
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
    
    @objc func presentFilter() {
        let vc = FilterViewController(onDismiss: fetchIsseus)
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredIssues = issues.filter({ (i) -> Bool in
            return i.title?.lowercased().contains(searchText.lowercased()) ?? false
        })
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
        return isFiltering ? filteredIssues.count : issues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueCardTableViewCell.self)) as? IssueCardTableViewCell else { return UITableViewCell() }
        
        let issue = isFiltering ? filteredIssues[indexPath.row] : issues[indexPath.row]
        
        cell.title = issue.title
//        cell.state = issue.state
//        cell.createdAt = issue.created_at
            
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IssueCardTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewControlller(issue: isFiltering ? filteredIssues[indexPath.row] : issues[indexPath.row])
        if (mode == .favorites) {
            vc.onSave = issueUseCase?.fetchIssues
        }
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
}

