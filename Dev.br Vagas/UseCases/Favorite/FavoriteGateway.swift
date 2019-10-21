//
//  FavoriteGateway.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

protocol FavoriteGateway {
    func toggleFavorite(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void)
    func isSaved(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void)
}
