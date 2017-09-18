//
//  MainNavigationController.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
//        let isLoggedIn = true
        
        //  Using a function instead will supress the "Will never be executed" warning.
//        if isLoggedIn {
        if isLoggedIn() {
            let homeController = HomeController()
            viewControllers = [homeController]
        } else {
            /* 2017-09-18 13:10:00.827 LBTA-17-audible[84991:3994569] Warning: Attempt to present <LBTA_17_audible.LoginController: 0x7fbe0c707310> on <LBTA_17_audible.MainNavigationController: 0x7fbe0e01e600> whose view is not in the window hierarchy! */
            /* Solution is to that we need to present it a little bit after the entire application window has been loaded. */
//            let loginController = LoginController()
//            present(loginController, animated: true, completion: {
//            })
            
            perform(#selector(showLoginController), with: nil, afterDelay: 0.01)
        }
    }
    
    private func isLoggedIn() -> Bool {
//        return UserDefaults.standard.bool(forKey: "isLoggedIn")
        return UserDefaults.standard.isLoggedIn()
    }
    
    func showLoginController() {
        let loginController = LoginController()
        present(loginController, animated: true, completion: {
        })
    }
    
}
