//
//  AppDelegate.swift
//  LBTA-4-rss-reader
//
//  Created by Alexander Baran on 27/08/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

//        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
//        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 0
//            //            layout.headerReferenceSize = CGSizeMake(view.frame.width, 50)
//            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
//        }
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 50)
        
        // This method relies on the system to auto size the cell based on what's inside of it. Also have to provide a method to the cell. preferredLayoutAttributesFitting
        // You can make this anything you want. But it did not work here, must do it inside SearchFeedController class for some reason.
//        layout.estimatedItemSize = CGSize(width: UIScreen.main.bounds.width, height: 100)
        
        
        let searchFeedController = SearchFeedController(collectionViewLayout: layout)
        
        window?.rootViewController = UINavigationController(rootViewController: searchFeedController)
        
//        UINavigationBar.appearance().barTintColor = UIColor.redColor()
        UINavigationBar.appearance().barTintColor = UIColor.red
//        UINavigationBar.appearance().titleTextAttributes = [
//            NSForegroundColorAttributeName: UIColor.whiteColor(),
//            NSFontAttributeName: UIFont.boldSystemFontOfSize(18)
//        ]
        UINavigationBar.appearance().titleTextAttributes = [
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont.boldSystemFont(ofSize: 18)
        ]
        
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIApplication.shared.statusBarStyle = .lightContent
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

