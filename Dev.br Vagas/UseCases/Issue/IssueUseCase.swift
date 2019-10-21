//
//  IssueUseCase.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

enum IssueUseCaseResult<Issue> {
    case sucess(Issue)
    case failure(Error?)
}

class IssueUseCase {
    private let gateway: IssueGateway
    private let presenter: IssuePresenter
    
    init(gateway: IssueGateway, presenter: IssuePresenter) {
        self.gateway = gateway
        self.presenter = presenter
    }
    
    func fetchAllIssues() {
        gateway.fetchAllIssues(completion: presenter.presentResponse(result:))
    }
    
    func fetchIssue(with id: Int) {
        gateway.fetchIssue(with: id, completion: presenter.presentResponse(result:))
    }
    
}
