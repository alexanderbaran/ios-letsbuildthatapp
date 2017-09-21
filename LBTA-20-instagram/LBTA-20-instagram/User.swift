//
//  User.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

struct User {
    
    let username: String
    let profileImgUrl: String
    
    init(dictionary: [String: Any]) {
        self.username = dictionary["username"] as? String ?? ""
        self.profileImgUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
