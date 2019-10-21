//
//  Presenter.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import UIKit

protocol IssuePresenter {
    func presentResponse(result: IssueUseCaseResult<[Issue]>)
}
