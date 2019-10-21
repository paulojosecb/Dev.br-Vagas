//
//  FavoriteGateway.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

protocol FavoriteGateway {
    func toggleFavorite(with number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void)
    func isSaved(number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void)
}
