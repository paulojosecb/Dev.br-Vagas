//
//  UserDefaultManager.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 21/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

class UserDefaultManager: FavoriteGateway {
    
    func fetchFavorites(completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void) {
        
        do {
            let issues = try getIssues()
            completion(.fetched(issues))
        } catch let error {
            completion(.failure(error))
        }
        
    }
    
    func isSaved(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void) {
        do {
            let issues = try getIssues()
            
            let saved = issues.first { (i) -> Bool in
                i == issue
            }
            
            completion(.saved(saved != nil ? true : false))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    func toggleFavorite(issue: Issue, completion: (FavoriteUseCaseResult<Bool, Issue>) -> Void) {
        
        do {
            var issues = try getIssues()
            
            if (issues.contains(issue)) {
                let filteredIssues = issues.filter { (i) -> Bool in
                    i != issue
                }
                
                try save(filteredIssues)
                completion(.removed)
            } else {
                issues.append(issue)
                
                try save(issues)
                completion(.added)
            }
            
        } catch let error {
            completion(.failure(error))
        }
    
    }
    
    private func getIssues() throws -> [Issue] {
        guard let savedIssuesData = UserDefaults.standard.object(forKey: "SavedItems") as? Data else {
            return [Issue]()
        }
        
        guard let savedIssues = try? JSONDecoder().decode([Issue].self, from: savedIssuesData) else {
            throw CustomError(description: "Error decoding issue data")
        }
        return savedIssues
    }
    
    private func save(_ issues: [Issue]) throws {
        let enconded = try JSONEncoder().encode(issues)
        UserDefaults.standard.set(enconded, forKey: "SavedItems")
    }

}
