//
//  User.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

struct User {
    
    let uid: String
    let username: String
    let profileImgUrl: String
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.username = dictionary["username"] as? String ?? ""
        self.profileImgUrl = dictionary["profileImageUrl"] as? String ?? ""
    }
}
