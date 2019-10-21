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
    
    func fetchIssues() {
        gateway.fetchIssues(completion: presenter.presentResponse(result:))
    }
    
}
