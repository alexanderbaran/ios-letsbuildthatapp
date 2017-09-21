//
//  MainTabBarController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil {
            /* When the application launches for the very first time, non of the views, the MainTabController is not set up properly yet, so this right here
             lets us wait until the MainTabBarController is inside of the UI and then we present it. */
            DispatchQueue.main.async {
                let loginController = LoginController()
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            }
            return
        }
        
        /* Flow layout is layout mechanism that decides how your collection view lays out each one of these cells. Flow layout basically means the collection view needs to lay out each one of these grid cells in a perhaps horizontal fashion and once it reaches the end of the row then it needs to how to flow on to the next row. Ø: Kind of like floating in web development. */
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let navController = UINavigationController(rootViewController: userProfileController)
        navController.tabBarItem.image = UIImage(named: "profile_unselected")
        navController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
//        view.backgroundColor = .blue
        viewControllers = [navController, UIViewController()]
    }
    
}
