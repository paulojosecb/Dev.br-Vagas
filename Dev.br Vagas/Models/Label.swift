//
//  Label.swift
//  Dev.br Vagas
//
//  Created by Paulo José on 22/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

class Label: NSObject, Codable {
    
    var id: Int?
    var name: String?
    var color: String?
    
    static func ==(lhs: Label, rhs: Label) -> Bool {
        return lhs.id == rhs.id
    }
    
    func isOnCollection(_ issues: [Label]) -> Bool {
        let firstLabel = issues.first { (l) -> Bool in
            l.id == self.id
        }
        return firstLabel != nil ? true : false
    }
}
