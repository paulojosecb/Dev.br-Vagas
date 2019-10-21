//
//  FavoriteUseCase.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

enum FavoriteUseCaseResult<Bool> {
    case added
    case removed
    case saved(Bool)
    case Failuer(Error?)
}

class FavoriteUseCase {
    
    let gateway: FavoriteGateway
    
    
    init(gateway: FavoriteGateway) {
        self.gateway = gateway
    }
    
    func toggleFavorite(with number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void) {
        gateway.toggleFavorite(with: number, completion: completion)
    }
    
    func isSaved(number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void) {
        gateway.isSaved(number: number, completion: completion)
    }
}
