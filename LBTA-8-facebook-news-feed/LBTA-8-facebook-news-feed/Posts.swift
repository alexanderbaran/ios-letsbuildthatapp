//
//  Posts.swift
//  LBTA-8-facebook-news-feed
//
//  Created by Alexander Baran on 08/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

class Post: SafeJsonObject {
    var name: String?
    var profileImageName: String?
    var statusText: String?
    var statusImageName: String?
    var numLikes: NSNumber?
    var numComments: NSNumber?
    
    var statusImageUrl: String?
    
    var location: Location?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "location" {
            location = Location()
            location?.setValuesForKeys(value as! [String: Any])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

// Using this in case there are some keys in the json and we don't have the properties for it in our class.
class SafeJsonObject: NSObject {
    override func setValue(_ value: Any?, forKey key: String) {
        let selectorString = "set\(key.uppercased().characters.first!)\(String(key.characters.dropFirst())):"
        let selector = Selector(selectorString)
        if responds(to: selector) {
            super.setValue(value, forKey: key)
        }
    }
}

class Location: NSObject {
    var city: String?
    var state: String?
}

class Posts {
    var postsList: [Post] = []
    
//    init() {
//        let postMark = Post()
//        postMark.name = "Mark Zuckerberg"
//        postMark.profileImageName = "zuckprofile"
//        postMark.statusText = "By giving people the power to share, we're making the world more transparent."
//        postMark.statusImageName = "zuckdog"
//        postMark.numLikes = 400
//        postMark.numComments = 123
//        postMark.statusImageUrl = "https://media.wired.com/photos/593222b926780e6c04d2a195/master/w_2400,c_limit/Zuck-TA-AP_17145748750763.jpg"
//        
//        let postSteve = Post()
//        postSteve.name = "Steve Jobs"
//        postSteve.profileImageName = "steve_profile"
//        postSteve.statusText = "Design is not just what it looks like and feels like. Design is how it works.\n\n" + "Being the richest man in the cemetery doesn't matter to me. Going to bed at night saying we've done something wonderful, that's what matters to me.\n\n" + "Sometimes when you innovate, you make mistakes. It is best to admit them quickly, and get on with improving your other innovations."
//        postSteve.statusImageName = "steve_status"
//        postSteve.numLikes = 1000
//        postSteve.numComments = 55
//        postSteve.statusImageUrl = "https://f.ptcdn.info/945/043/000/o9ih6uki2JInER6c3hG-o.jpg"
//        
//        let postGandhi = Post()
//        postGandhi.name = "Mahatma Gandhi"
//        postGandhi.profileImageName = "gandhi_profile"
//        postGandhi.statusText = "Live as if you were to die tomorrow; learn as if you were to live forever.\n" + "The weak can never forgive. Forgiveness is the attribute of the strong.\n" + "Happiness is when what you think, what you say, and what you do are in harmony."
//        postGandhi.statusImageName = "gandhi_status"
//        postGandhi.numLikes = 333
//        postGandhi.numComments = 22
//        postGandhi.statusImageUrl = "https://i.imgur.com/paLR1Md.jpg"
//        
//        let postBillGates = Post()
//        postBillGates.name = "Bill Gates"
//        postBillGates.profileImageName = "bill_gates_profile"
//        postBillGates.statusText = "Success is a lousy teacher. It seduces smart people into thinking they can't lose.\n\n" + "Your most unhappy customers are your greatest source of learning.\n\n" + "As we look ahead into the next century, leaders will be those who empower others."
//        postBillGates.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/gates_background.jpg"
//        
//        let postTimCook = Post()
//        postTimCook.name = "Tim Cook"
//        postTimCook.profileImageName = "tim_cook_profile"
//        postTimCook.statusText = "The worst thing in the world that can happen to you if you're an engineer that has given his life to something is for someone to rip it off and put their name on it."
//        postTimCook.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/Tim+Cook.png"
//        
//        let postDonaldTrump = Post()
//        postDonaldTrump.name = "Donald Trump"
//        postDonaldTrump.profileImageName = "donald_trump_profile"
//        postDonaldTrump.statusText = "An ‘extremely credible source’ has called my office and " + "told me that Barack Obama’s birth certificate is a fraud."
//        postDonaldTrump.statusImageUrl = "https://s3-us-west-2.amazonaws.com/letsbuildthatapp/trump_background.jpg"
//        
//        postsList = [postMark, postSteve, postGandhi, postBillGates, postTimCook, postDonaldTrump]
//    }
    
    func numberOfPosts() -> Int {
        return postsList.count
    }
    
    subscript(index: Int) -> Post {
        get {
            return postsList[index]
        }
    }
}










