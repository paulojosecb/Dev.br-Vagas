//
//  UserImageGateway.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

protocol UserImageGateway {
    func fetchUserImage(with url: String, completion: @escaping (ImageFetchResult<Data>) -> Void)
}
