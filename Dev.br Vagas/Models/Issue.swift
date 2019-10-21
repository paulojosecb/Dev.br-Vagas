//
//  Issue.swift
//  recrutamento-ios
//
//  Created by Paulo José on 15/10/19.
//  Copyright © 2019 Paulo José. All rights reserved.
//

import Foundation

class Issue: NSObject, Codable {
    
    var title: String?
    var body: String?
    var state: String?
    var number: Int?
    var user: User?
    var html_url: String?
    var created_at: String?
    
    init(title: String, body: String, state: String, number: Int) {
        self.title = title
        self.body = body
        self.state = state
        self.number = number
        super.init()
    }

}
