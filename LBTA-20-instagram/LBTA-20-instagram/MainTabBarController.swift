//
//  MainTabBarController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class MainTabBarController: UITabBarController, UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.index(of: viewController)
        // Disable the plus tab bar button.
        if index == 2 {
            let layout = UICollectionViewFlowLayout()
            let photoSelectorController = PhotoSelectorController(collectionViewLayout: layout)
            let navigationController = UINavigationController(rootViewController: photoSelectorController)
            present(navigationController, animated: true, completion: nil)
            return false
        }
//        print(index)
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // We do need to set the delegate to self here since we are conforming to protocol UITabBarControllerDelegate.
        self.delegate = self
        
//        if Auth.auth().currentUser == nil {
//            /* When the application launches for the very first time, non of the views, the MainTabController is not set up properly yet, so this right here
//             lets us wait until the MainTabBarController is inside of the UI and then we present it. */
//            DispatchQueue.main.async {
//                let loginController = LoginController()
//                // This method did not work that Ø tried.
////                loginController.mainTabBarController = self
//                let navigationController = UINavigationController(rootViewController: loginController)
//                self.present(navigationController, animated: false, completion: nil)
//            }
//            return
//        }
        
        if Auth.auth().currentUser == nil {
            // No need to do anything else for now so we return.
            return
        }
        
        setupViewControllers()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // If we do it here we don't have to dispatch queue. Also it is less like flickery when we do it here instead of above.
        if Auth.auth().currentUser == nil {
            let loginController = LoginController()
            let navigationController = UINavigationController(rootViewController: loginController)
            self.present(navigationController, animated: false, completion: nil)
            return
        }
    }
    
    func setupViewControllers() {
        
        let homeFlowLayout = UICollectionViewFlowLayout()
        let homeController = HomeController(collectionViewLayout: homeFlowLayout)
        let homeNavigationController = templateNavigationController(unselectedImageName: "home_unselected", selectedImageName: "home_selected", rootViewController: homeController)
        
        let searchFlowLayout = UICollectionViewFlowLayout()
        let userSearchController = UserSearchController(collectionViewLayout: searchFlowLayout)
        let searchNavigationController = templateNavigationController(unselectedImageName: "search_unselected", selectedImageName: "search_selected", rootViewController: userSearchController)
        
        let plusNavigationController = templateNavigationController(unselectedImageName: "plus_unselected", selectedImageName: "plus_unselected")
        let likeNavigationController = templateNavigationController(unselectedImageName: "like_unselected", selectedImageName: "like_selected")
        
        /* Flow layout is layout mechanism that decides how your collection view lays out each one of these cells. Flow layout basically means the collection view needs to lay out each one of these grid cells in a perhaps horizontal fashion and once it reaches the end of the row then it needs to how to flow on to the next row. Ø: Kind of like floating in web development. */
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        
        let userProfileNavigationController = UINavigationController(rootViewController: userProfileController)
        userProfileNavigationController.tabBarItem.image = UIImage(named: "profile_unselected")
        userProfileNavigationController.tabBarItem.selectedImage = UIImage(named: "profile_selected")
        
        tabBar.tintColor = .black
        
        viewControllers = [homeNavigationController, searchNavigationController, plusNavigationController, likeNavigationController, userProfileNavigationController]
        
        /* This is not well documented in Apple docs. Have to do it after we set up all of the controllers inside of array as above. */
        // Modify tab bar item instes.
        guard let items = tabBar.items else { return }
        for item in items {
            // Adding a negative 4 at the bottom to fix the aspect ratio.
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: -4, right: 0)
        }
        
    }
    
    private func templateNavigationController(unselectedImageName: String, selectedImageName: String, rootViewController: UIViewController = UIViewController()) -> UINavigationController {
        let viewController = rootViewController
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.tabBarItem.image = UIImage(named: unselectedImageName)
        navigationController.tabBarItem.selectedImage = UIImage(named: selectedImageName)
        return navigationController
    }
    
}

















