//
//  ViewController.swift
//  LBTA-12-google-login-sdk
//
//  Created by Alexander Baran on 09/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Google

class ViewController: UIViewController, GIDSignInUIDelegate, GIDSignInDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var error: NSError?
        GGLContext.sharedInstance().configureWithError(&error)
        
        if error != nil {
            print(error!)
            return
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        
        let signInButton = GIDSignInButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        signInButton.center = view.center
        view.addSubview(signInButton)

    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if (error != nil) {
            print("\(error.localizedDescription)")
            return
        }
        // Perform any operations on signed in user here.
        //            let userId = user.userID                  // For client-side use only!
        //            let idToken = user.authentication.idToken // Safe to send to the server
        let fullName = user.profile.name
        //            let givenName = user.profile.givenName
        //            let familyName = user.profile.familyName
        let email = user.profile.email
        print(fullName!, email!)
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        
    }

}

