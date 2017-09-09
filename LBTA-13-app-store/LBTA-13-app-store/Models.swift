//
//  Models.swift
//  LBTA-13-app-store
//
//  Created by Alexander Baran on 09/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class FeaturedApps: NSObject {
    var bannerCategory: AppCategory?
    var appCategories: [AppCategory]?
    
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "categories" {
            appCategories = [AppCategory]()
            for dict in value as! [[String: Any]] {
                let appCategory = AppCategory()
                appCategory.setValuesForKeys(dict)
                appCategories?.append(appCategory)
            }
        } else if key == "bannerCategory" {
            bannerCategory = AppCategory()
            bannerCategory?.setValuesForKeys(value as! [String: Any])
        } else {
            super.setValue(value, forKey: key)
        }
    }
}

class App: NSObject {
    var id: NSNumber?
    var name: String?
    var category: String?
    var imageName: String?
    var price: NSNumber?
}

class AppCategory: NSObject {
    
    var name: String?
    var apps: [App]?
    var type: String?
    
    /* We do this so that the type of apps will be [App] and not [NSDictionary]. */
    override func setValue(_ value: Any?, forKey key: String) {
        if key == "apps" {
            apps = [App]()
            for dict in value as! [[String: Any]] {
                let app = App()
                app.setValuesForKeys(dict)
                apps?.append(app)
            }
        } else {
            super.setValue(value, forKey: key)
        }
    }
    
    static func fetchFeaturedApps(completionHandler: @escaping (FeaturedApps) -> ()) {
        
        let urlString = "https://api.letsbuildthatapp.com/appstore/featured"
        let url = URL(string: urlString)!
        
        let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                let featuredApps = FeaturedApps()
                featuredApps.setValuesForKeys(json)
                
                
//                var appCategories = [AppCategory]()
//                for dict in json["categories"] as! [[String: Any]] {
//                    let appCategory = AppCategory()
//                    appCategory.setValuesForKeys(dict)
//                    appCategories.append(appCategory)
//                }
//                print(appCategories)
                DispatchQueue.main.async {
                    completionHandler(featuredApps)
                }
            } catch let error {
                print(error)
            }
        }
        
        task.resume()
    }
    
//    static func sampleAppCategories() -> [AppCategory] {
//        
//        let bestNewAppsCategory = AppCategory()
//        bestNewAppsCategory.name = "Best New Apps"
//        var apps = [App]()
//        let frozenApp = App()
//        frozenApp.name = "Disney Build It: Frozen"
//        frozenApp.imageName = "frozen"
//        frozenApp.category = "Entertainment"
//        frozenApp.price = NSNumber(floatLiteral: 3.99)
//        apps.append(frozenApp)
//        bestNewAppsCategory.apps = apps
//        
//        let bestNewGamesCategory = AppCategory()
//        bestNewGamesCategory.name = "Best New Games"
//        var bestNewGamesApp = [App]()
//        let telepaintApp = App()
//        telepaintApp.name = "Telepaint"
//        telepaintApp.imageName = "telepaint"
//        telepaintApp.category = "Games"
//        telepaintApp.price = NSNumber(floatLiteral: 2.99)
//        bestNewGamesApp.append(telepaintApp)
//        bestNewGamesCategory.apps = bestNewGamesApp
//        
//        return [bestNewAppsCategory, bestNewGamesCategory]
//    }
}
