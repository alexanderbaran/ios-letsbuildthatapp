//
//  Post.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

// structs have default initializers for their properties unlike classes. But once you provide your own initializer then the default one is no longer valid.
struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
    
}
