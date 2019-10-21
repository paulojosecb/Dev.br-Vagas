//
//  FavoriteUseCase.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

enum FavoriteUseCaseResult<Bool, Issue> {
    case added
    case removed
    case saved(Bool)
    case fetched([Issue])
    case failure(Error?)
}

class FavoriteUseCase {
    
    let gateway: FavoriteGateway
    
    
    init(gateway: FavoriteGateway) {
        self.gateway = gateway
    }
    
    func toggleFavorite(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void) {
        gateway.toggleFavorite(issue: issue, completion: completion)
    }
    
    func isSaved(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void) {
        gateway.isSaved(issue: issue, completion: completion)
    }
}
