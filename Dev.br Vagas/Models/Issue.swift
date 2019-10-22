//
//  Issue.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

struct Issue: Codable, Equatable {
    
    var title: String?
    var body: String?
    var state: String?
    var number: Int?
    var user: User?
    var html_url: String?
    var created_at: String?
    var labels: [Label]?
    
    static func ==(lhs: Issue, rhs: Issue) -> Bool {
        return lhs.number == rhs.number
    }
}
