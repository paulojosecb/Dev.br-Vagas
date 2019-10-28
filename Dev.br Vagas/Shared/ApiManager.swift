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
    
    func fetchIssues(with filters: [Label]? = nil, completion: @escaping (IssueUseCaseResult<[Issue]>) -> Void) {
        let params = self.transformInParams(labels: filters)
        print(params)
        Alamofire.request("\(base_url)issues?labels=\(params)").responseData { (data) in
            do {
                guard let data = data.data else { return }
                if (data.isEmpty) {
                    completion(.sucess([Issue]()))
                } else {
                    let issues = try JSONDecoder().decode([Issue].self, from: data)
                    completion(.sucess(issues))
                }
                
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
        Alamofire.request(url).responseData { (data) in
            
            guard let data = data.data else {
                let error = CustomError(description: "Não foi possível dar fetch na imagem")
                completion(.failure(error))
                return
            }
            
            completion(.sucess(data))
        }
    }
    
    func transformInParams(labels: [Label]?) -> String {
        guard let labels = labels else { return ""}
        
        var param = ""
        
        for (index, label) in labels.enumerated() {
            guard let name = label.name else { break }
            param.append("\(name)")
            
            if (index < labels.count - 1) {
                param.append(",")
            }
        }
        
        return param
    }
    
    
    
}
