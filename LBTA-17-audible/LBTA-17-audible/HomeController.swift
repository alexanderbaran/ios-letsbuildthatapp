//
//  HomeController.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class HomeController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "We're logged in"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(handeLogout))
        
//        view.backgroundColor = .yellow
        let imageView = UIImageView(image: UIImage(named: "home"))
        view.addSubview(imageView)
        // 20 pixels for the status bar and 44 for the nav bar.
        _ = imageView.anchor(view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 64, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func handeLogout() {
        /* Sometimes the simluator does not save it properly sometimes if you run and re run. Better to press stop first, then run later. */
//        UserDefaults.standard.set(false, forKey: "isLoggedIn")
//        UserDefaults.standard.synchronize()
        UserDefaults.standard.setIsLoggedIn(value: false)
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
    
}
