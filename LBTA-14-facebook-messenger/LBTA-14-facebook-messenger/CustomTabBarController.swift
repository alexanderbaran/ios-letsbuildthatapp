//
//  CustomTabBarController.swift
//  LBTA-14-facebook-messenger
//
//  Created by Alexander Baran on 10/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup our custom view controllers.
        let layout = UICollectionViewFlowLayout()
        let friendsController = FriendsController(collectionViewLayout: layout)
        let recentMessagesNavController = UINavigationController(rootViewController: friendsController)
        recentMessagesNavController.tabBarItem.title = "Recent"
        recentMessagesNavController.tabBarItem.image = UIImage(named: "recent")
        
        viewControllers = [
            recentMessagesNavController,
            createDummyNavControllerWithTitle(title: "Calls", imageName: "calls"),
            createDummyNavControllerWithTitle(title: "Groups", imageName: "groups"),
            createDummyNavControllerWithTitle(title: "People", imageName: "people"),
            createDummyNavControllerWithTitle(title: "Settings", imageName: "settings")
        ]
    }
    
    private func createDummyNavControllerWithTitle(title: String, imageName: String) -> UINavigationController {
        
        let viewController = UIViewController()
        viewController.navigationItem.title = title
        viewController.view.backgroundColor = UIColor.white
        
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        
        return navController
    }
}
