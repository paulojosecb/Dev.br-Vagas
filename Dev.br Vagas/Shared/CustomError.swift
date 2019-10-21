//
//  CustomError.swift
//  recrutamento-ios
//
//  Created by Paulo José on 16/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

class CustomError: Error {
    let description: String
    
    init(description: String) {
        self.description = description
    }
}
