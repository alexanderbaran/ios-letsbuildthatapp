//
//  ApiService.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 13/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ApiService: NSObject {
    // Singleton.
    static let sharedInstance = ApiService()
    
    // https://stackoverflow.com/questions/42214840/swift-3-closure-use-of-non-escaping-parameter-may-allow-it-to-escape
    func fetchVideos(completion: @escaping ([Video]) -> ()) {
        
        let url = URL(string: "https://s3-us-west-2.amazonaws.com/youtubeassets/home.json")!
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            //            let str = String(data: data!, encoding: String.Encoding.utf8)
            //            print(str)
            // https://stackoverflow.com/questions/40057854/what-do-jsonserialization-options-do-and-how-do-they-change-jsonresult
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//                self.videos = [Video]()
                var videos = [Video]()
                for dictionary in json as! [[String: Any]] {
                    //                    print(dictionary["title"])
                    
                    guard let channelDictionary = dictionary["channel"] as? [String: Any] else {
                        print("channel not a dictionary")
                        break
                    }
                    
                    let channel = Channel()
                    channel.name = channelDictionary["name"] as? String
                    channel.profileImageName = channelDictionary["profile_image_name"] as? String
                    
                    let video = Video()
                    video.title = dictionary["title"] as? String
                    video.thumbnailImageName = dictionary["thumbnail_image_name"] as? String
                    video.channel = channel
                    
                    videos.append(video)
                    
                    DispatchQueue.main.async {
                        //                self.collectionView?.reloadData()
                        completion(videos)
                    }                    
                }
            } catch let error {
                print(error)
            }
        }
        task.resume()
    }
}
