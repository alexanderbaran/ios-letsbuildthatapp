//
//  ViewController.swift
//  LBTA-6-facebook-ios-sdk
//
//  Created by Alexander Baran on 07/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(loginButton)
        loginButton.center = view.center
        
        // To figure out when we have logged in by using a delegate method.
        loginButton.delegate = self
        
//        if let token = FBSDKAccessToken.current() {
        if (FBSDKAccessToken.current()) != nil {
//            print(token)
            fetchProfile()
        }
    }

    func fetchProfile() {
        print("Fetched profile.")
        
        let parameters = ["fields": "email, first_name, last_name, picture.type(large)"]
        FBSDKGraphRequest(graphPath: "me", parameters: parameters).start { (connection: FBSDKGraphRequestConnection?, result: Any?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            let result = result as? NSDictionary
            if let email = result?["email"] as? String {
                print(email)
            }
            
            if let picture = result?["picture"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String {
                print(url)
            }
        }
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Completed login.")
        fetchProfile()
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Completed logout.")
    }
    
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
    
}

