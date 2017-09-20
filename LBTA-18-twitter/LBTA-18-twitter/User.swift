//
//  User.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 19/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct User: JSONDecodable {
    let name: String
    let username: String
    let bioText: String
    let profileImageUrl: String
    
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.username = json["username"].stringValue
        self.bioText = json["bio"].stringValue
        self.profileImageUrl = json["profileImageUrl"].stringValue
    }
}
