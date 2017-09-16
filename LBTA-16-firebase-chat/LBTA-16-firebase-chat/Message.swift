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
    
    var imageUrl: String?
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
    
    var videoUrl: String?
    
    func chatPartnerId() -> String? {
        if fromId == Auth.auth().currentUser?.uid {
            return toId
        }
        return fromId
    }
    
    /* The application should no longer crash every time we introduce a new property to our message node. */
    init(dictionary: [String: Any]) {
        super.init()
        text = dictionary["text"] as? String
        fromId = dictionary["fromId"] as? String
        toId = dictionary["toId"] as? String
        timestamp = dictionary["timestamp"] as? NSNumber
        
        imageUrl = dictionary["imageUrl"] as? String
        imageWidth = dictionary["imageWidth"] as? NSNumber
        imageHeight = dictionary["imageHeight"] as? NSNumber
        
        videoUrl = dictionary["videoUrl"] as? String
    }
}
