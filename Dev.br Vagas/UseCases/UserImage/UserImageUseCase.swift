//
//  UserImageUseCase.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

enum ImageFetchResult<Data> {
    case sucess(Data)
    case failure(Error?)
}

class UserImageUseCase {
    
    private let gateway: UserImageGateway
    private let presenter: UserImagePresenter
    
    init(gateway: UserImageGateway, presenter: UserImagePresenter) {
        self.gateway = gateway
        self.presenter = presenter
    }
    
    func fetchUserImage(with url: String) {
        gateway.fetchUserImage(with: url, completion: presenter.presentUserImage(result:))
    }
}
