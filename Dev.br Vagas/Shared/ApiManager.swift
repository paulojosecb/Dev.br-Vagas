//
//  ApiManager.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation
import Alamofire

class ApiManager: IssueGateway, UserImageGateway, LabelGateway {
    
    func add(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void)) {
        
    }
    
    func remove(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void)) {
        
    }
    
    let base_url = "https://api.github.com/repos/frontendbr/vagas/"
    
    func fetchIssues(completion: @escaping (IssueUseCaseResult<[Issue]>) -> Void) {
        Alamofire.request("\(base_url)issues").responseData { (data) in
            do {
                guard let data = data.data else { return }
                let issues = try JSONDecoder().decode([Issue].self, from: data)
                completion(.sucess(issues))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
    func fetchLabels(completion: @escaping ((LabelUseCaseResult<Label>) -> Void)) {
        Alamofire.request("\(base_url)labels").responseData { (data) in
            do {
                guard let data = data.data else { return }
                let labels = try JSONDecoder().decode([Label].self, from: data)
                completion(.sucess(labels))
            } catch let error {
                completion(.failure(error))
            }
        }
    }
    
//    func fetchIssue(with id: Int, completion: @escaping (IssueUseCaseResult<[Issue]>) -> Void) {
//        Alamofire.request("\(base_url)/\(id)").responseData { (data) in
//            do {
//                guard let data = data.data else { return }
//                let issues = try JSONDecoder().decode([Issue].self, from: data)
//                completion(.sucess(issues))
//            } catch let error {
//                completion(.failure((error)))
//            }
//        }
//    }
        
    func fetchUserImage(with url: String, completion: @escaping (ImageFetchResult<Data>) -> Void) {
        Alamofire.request("\(base_url)issues").responseData { (data) in
            
            guard let data = data.data else {
                let error = CustomError(description: "Não foi possível dar fetch na imagem")
                completion(.failure(error))
                return
            }
            
            completion(.sucess(data))
        }
    }
    
    
    
}
