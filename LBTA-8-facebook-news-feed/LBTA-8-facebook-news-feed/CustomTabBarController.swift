//
//  CustomTabBarController.swift
//  LBTA-8-facebook-news-feed
//
//  Created by Alexander Baran on 08/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let feedController = FeedController(collectionViewLayout: layout)
        let navigationController = UINavigationController(rootViewController: feedController)
        // This title only corresponds to tab bar button label.
        navigationController.title = "News Feed"
        navigationController.tabBarItem.image = UIImage(named: "news_feed_icon")
        
        let friendRequestsController = FriendRequestsController()
        let secondNavigationController = UINavigationController(rootViewController: friendRequestsController)
        secondNavigationController.title = "Requests"
        secondNavigationController.tabBarItem.image = UIImage(named: "requests_icon")
        
        let messengerViewController = UIViewController()
        messengerViewController.navigationItem.title = "Messenger"
        messengerViewController.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let messengerNavigationController = UINavigationController(rootViewController: messengerViewController)
        messengerNavigationController.title = "Messenger"
        messengerNavigationController.tabBarItem.image = UIImage(named: "messenger_icon")
        
        let notificationsViewController = UIViewController()
        notificationsViewController.navigationItem.title = "Notifications"
        notificationsViewController.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let notificationsNavigationController = UINavigationController(rootViewController: notificationsViewController)
        notificationsNavigationController.title = "Notifications"
        notificationsNavigationController.tabBarItem.image = UIImage(named: "globe_icon")
        
        let moreViewController = UIViewController()
        moreViewController.navigationItem.title = "More"
        moreViewController.view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        let moreNavigationController = UINavigationController(rootViewController: moreViewController)
        moreNavigationController.title = "More"
        moreNavigationController.tabBarItem.image = UIImage(named: "more_icon")
        
        viewControllers = [navigationController, secondNavigationController, messengerNavigationController, notificationsNavigationController, moreNavigationController]
        
        // Turn off transparency.
        tabBar.isTranslucent = false
        
        // This is to set the height of the top border of the tab menu.
        /* Think of this as another view. So CALayer is what a UIView is based upon, and CALayer gives you more control of what is happening underneath the hood of a ui view. */
        let topBorder = CALayer()
        topBorder.frame = CGRect(x: 0, y: 0, width: 1000, height: 0.5)
        topBorder.backgroundColor = UIColor.rgb(red: 229, green: 231, blue: 235).cgColor
        tabBar.layer.addSublayer(topBorder)
        tabBar.clipsToBounds = true
    }
}
