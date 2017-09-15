//
//  Video.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

class SafeJsonObject: NSObject {
    
    override func setValue(_ value: Any?, forKey key: String) {
        // https://www.youtube.com/watch?v=11aHute59QQ
        let uppercasedFirstCharacter = String(describing: key.characters.first!).uppercased()
        let range = key.startIndex..<key.index(key.startIndex, offsetBy: 1)
        let selectorString = key.replacingCharacters(in: range, with: uppercasedFirstCharacter)
        let selector = NSSelectorFromString("set\(selectorString):")
        let responds = self.responds(to: selector)
        
        if !responds {
            return
        }
        
        super.setValue(value, forKey: key)
    }
    
}

class Video: SafeJsonObject {
//    var thumbnailImageName: String?
    var thumbnail_image_name: String?
    var title: String?
//    var numberOfViews: NSNumber?
    var number_of_views: NSNumber?
    var uploadDate: NSDate?
    var duration: NSNumber?
    
    var channel: Channel?
    
    init(dictionary: [String: Any]) {
        super.init()
        setValuesForKeys(dictionary)
    }
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "channel" {
            guard let dictionary = value as? [String: Any] else {
                print("value not a dictionary")
                return
            }
//            let channel = Channel()
            self.channel = Channel()
            channel?.setValuesForKeys(dictionary)
//            self.channel = channel
        } else {
            super.setValue(value, forKey: key)
        }
    }
}
