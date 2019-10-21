//
//  IssueUseCaseGateway.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

protocol IssueGateway {
    func fetchAllIssues(completion: @escaping (IssueUseCaseResult<[Issue]>) -> Void)
    func fetchIssue(with id: Int, completion: @escaping (IssueUseCaseResult<[Issue]>) -> Void)
}
