//
//  ViewController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 12/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout() {
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

