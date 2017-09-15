//
//  Message.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 14/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var text: String?
    var fromId: String?
    var toId: String?
    var timestamp: NSNumber?
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }
        return fromId
    }
}
