//
//  File.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 19/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation
import SwiftyJSON
import TRON

struct Tweet: JSONDecodable {
    let user: User
    let message: String
    
    init(json: JSON) {
        let userJson = json["user"]
        self.user = User(json: userJson)
        self.message = json["message"].stringValue
    }
}
