//
//  UserDefaultManager.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

class UserDefaultManager: FavoriteGateway {
    
    func isSaved(number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void) {
        let saved = UserDefaults.standard.object(forKey: "SavedItems") as? [Int] ?? [Int]()
        completion(.saved(saved.contains(number)))
    }
    
    func toggleFavorite(with number: Int, completion: (FavoriteUseCaseResult<Bool>) -> Void) {
        var saved = UserDefaults.standard.object(forKey: "SavedItems") as? [Int] ?? [Int]()
        
        if (saved.contains(number)) {
            let filterdSaved = saved.filter { (element) -> Bool in
                element != number
            }
            
            UserDefaults.standard.setValue(filterdSaved, forKeyPath: "SavedItems")
            completion(.removed)
        } else {
            saved.append(number)
            UserDefaults.standard.setValue(saved, forKeyPath: "SavedItems")
            completion(.added)
        }
    }
}
