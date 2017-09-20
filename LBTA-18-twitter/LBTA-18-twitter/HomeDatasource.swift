//
//  HomeDatasource.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import LBTAComponents
import TRON
import SwiftyJSON

extension Collection where Iterator.Element == JSON {
    func decode<T: JSONDecodable>() throws -> [T] {
        return try map({ try T(json: $0) })
    }
}

class HomeDatasource: Datasource, JSONDecodable {
    
//    let users: [User] = {
//        let brianUser = User(name: "Brian Voong", username: "@buildthatapp", bioText: "iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build iOS apps!", profileImage: "profile_image")
//        let rayUser = User(name: "Ray Wenderlich", username: "@rwenderlich", bioText: "Ray Wenderlich is an iPhone developer and tweets on topics related to iPhone, software, and gaming. Check out our conference.", profileImage: "ray_profile_image")
//        let kindleCourseUser = User(name: "Kindle Course", username: "@kindleCourse", bioText: "This recently released course on https://videos.letsbuildthatapp.com/basic-training provides some excellent guidance on how to use UITableView and UICollectionView.  This course also teaches some basics on the Swift language, for example If Statements and For Loops.  This will be an excellent purchase for you.", profileImage: "profile_image")
//        return [brianUser, rayUser, kindleCourseUser]
//    }()
//    
//    let tweets: [Tweet] = {
//        let brianUser = User(name: "Brian Voong", username: "@buildthatapp", bioText: "iPhone, iPad, iOS Programming Community. Join us to learn Swift, Objective-C and build iOS apps!", profileImage: "profile_image")
//        let tweet = Tweet(user: brianUser, message: "Welcome to episode 9 of the Twitter Series, really hope you guys are enjoying the series so far. I really really need a long text block to render out so we're going to stop here.")
//        let tweet2 = Tweet(user: brianUser, message: "This is the second tweet message for our sample project. Very very exciting message....")
//        return [tweet, tweet2]
//    }()
    
    let users: [User]
    let tweets: [Tweet]
    
    required init(json: JSON) throws {
        guard let usersJsonArray = json["users"].array, let tweetsJsonArray = json["tweets"].array else {
            throw NSError(domain: "com.letsbuildthatapp", code: 1, userInfo: [NSLocalizedDescriptionKey: "Parsing JSON was not valid."])
        }
//        self.users = usersJsonArray.map({ User(json: $0) })
//        self.tweets = tweetsJsonArray.map({ Tweet(json: $0) })
        self.users = try usersJsonArray.decode()
        self.tweets = try tweetsJsonArray.decode()
    }
    
    override func footerClasses() -> [DatasourceCell.Type]? {
        return [UserFooter.self]
    }
    
    override func headerClasses() -> [DatasourceCell.Type]? {
        return [UserHeader.self]
    }
    
    override func cellClasses() -> [DatasourceCell.Type] {
        return [UserCell.self, TweetCell.self]
    }
    
    override func item(_ indexPath: IndexPath) -> Any? {
        if indexPath.section == 1 {
            return tweets[indexPath.item]
        }
        return users[indexPath.item]
    }
    
    override func numberOfSections() -> Int {
        return 2
    }
    
    override func numberOfItems(_ section: Int) -> Int {
        if section == 1 {
            return tweets.count
        }
        return users.count
    }
}










