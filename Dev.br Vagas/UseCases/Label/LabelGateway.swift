//
//  LabelGateway.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 25/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

protocol LabelGateway {
    func fetchLabels(completion: @escaping ((LabelUseCaseResult<Label>) -> Void))
//    func add(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void))
//    func remove(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void))
}

extension LabelGateway {
    func add(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void)) {
        
    }
    func remove(label: Label, completion: @escaping ((LabelUseCaseResult<Label>) -> Void)) {
        
    }
}
