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
    
    var isLoading: Bool = false {
        didSet {
            contentView?.isLoading = isLoading
        }
    }
    
    var isEmpty: Bool = false {
        didSet {
            contentView?.isEmpty = isEmpty
        }
    }
    
    var contentView: HomeView?
    
    var issueUseCase: IssueUseCase?
    var selectedLabelsUseCase: LabelUseCase?
    
    let mode: HomeMode
    
    var issues: [Issue] = [] {
        didSet {
            guard let contentView = contentView else { return }
            self.contentView?.refreshControl.endRefreshing()
            contentView.tableView.reloadData()
            
            isEmpty = issues.count == 0 ? true : false
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
        controller.searchBar.tintColor = .black50
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black50]
        UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self]).defaultTextAttributes = [NSAttributedString.Key.font: UIFont.body]
        
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
        self.transitioningDelegate = self
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = mode == .all ? "Todas vagas" : "Favoritas"

        self.contentView = HomeView(frame: self.view.bounds, parentVC: self)
                        
        self.contentView?.tabBar.action1 = presentAll
        self.contentView?.tabBar.action2 = presentFavorites
        self.contentView?.onFilter = presentFilter
        
        self.contentView?.refreshControl.addTarget(self, action: #selector(fetchIsseus), for: .valueChanged)
        self.view = contentView
        
        issueUseCase = IssueUseCase(gateway: mode == .all ? ApiManager() : UserDefaultManager(), presenter: self)
        selectedLabelsUseCase = LabelUseCase(gateway: UserDefaultManager())
        
        self.navigationItem.searchController = self.searchController
        definesPresentationContext = true
    }
    
    @objc func fetchIsseus() {
        self.isLoading = true
        
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
    
    func reloadData() {
        if (mode == .favorites) {
            issueUseCase?.fetchIssues()
        } else {
            contentView?.tableView.reloadData()
        }
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
    
    func presentAll() {
        if (mode == .favorites) {
            let vc = HomeViewController(mode: .all)
            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func presentFavorites() {
        if (mode == .all) {
            let vc = HomeViewController(mode: .favorites)
            vc.modalPresentationStyle = .fullScreen
//            present(vc, animated: true, completion: nil)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }
    
    func presentFilter() {
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
            self.isLoading = false
        case .failure(_):
            presentErrorAlert()
            self.isLoading = false
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredIssues.count + 2 : issues.count + 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: IssueCardTableViewCell.self)) as? IssueCardTableViewCell else { return UITableViewCell() }
        
        if (indexPath.row >= (isFiltering ? filteredIssues.count : issues.count)) {
            let cell = UITableViewCell()
            cell.backgroundColor = .background
            return cell
        }
        
        let issue = isFiltering ? filteredIssues[indexPath.row] : issues[indexPath.row]
        
        cell.issue = issue
        cell.title = issue.title
        var tags: [String] = []
        
        for label in (issue.labels) ?? [Label]() {
            tags.append(label.name ?? "")
        }
        
        cell.tags = tags
        cell.selectionStyle = .none
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return IssueCardTableViewCell.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailsViewControlller(issue: isFiltering ? filteredIssues[indexPath.row] : issues[indexPath.row])
        vc.onSave = self.reloadData
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text ?? "")
    }
}

extension HomeViewController: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
}

