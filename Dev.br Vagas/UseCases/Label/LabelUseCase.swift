//
//  LabelUseCase.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 25/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

enum LabelUseCaseResult<Label> {
    case sucess([Label])
    case failure(Error?)
}

class LabelUseCase {
    private let gateway: LabelGateway
    
    init(gateway: LabelGateway) {
        self.gateway = gateway
    }
    
    func fetchLabels(completion: @escaping (LabelUseCaseResult<Label>) -> Void) {
        gateway.fetchLabels(completion: completion)
    }
    
    func add(label: Label, completion: @escaping (LabelUseCaseResult<Label>) -> Void) {
        gateway.add(label: label, completion: completion)
    }
    
    func remove(label: Label, completion: @escaping (LabelUseCaseResult<Label>) -> Void) {
        gateway.remove(label: label, completion: completion)
    }
}
