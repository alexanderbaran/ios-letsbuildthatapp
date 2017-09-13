//
//  ViewController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 12/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navigationController = UINavigationController(rootViewController: newMessageController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        // User is not logged in.
        if Auth.auth().currentUser?.uid == nil {
            // We want to present the controller after its been loaded.
            /* Fixes warnings like:
             Presenting view controllers on detached view controllers is discouraged ..
             Unbalanced calls to begin/end appearance transitions for .. */
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //            handleLogout()
        } else {
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value, with: { (snapshot: DataSnapshot) in
//                print(snapshot)
                if let dictionary = snapshot.value as? [String: Any] {
                    self.navigationItem.title = dictionary["name"] as? String
                }
            }, withCancel: nil)
        }
    }
    
    func handleLogout() {
        do {
            // Log out user.
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginController = LoginController()
//        navigationController?.pushViewController(loginController, animated: true)
        present(loginController, animated: true, completion: nil)
        // https://stackoverflow.com/questions/37722323/how-to-present-view-controller-from-right-to-left-in-ios-using-swift
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(loginController, animated: false, completion: nil)
    }
    
}











