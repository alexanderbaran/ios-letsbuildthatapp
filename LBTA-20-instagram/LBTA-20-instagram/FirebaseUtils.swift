//
//  FirebaseUtils.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation
import Firebase

extension Database {
    // @escaping keyword is because of retain cycles.
    static func fetchUserWithUID(uid: String, completion: @escaping (User) -> ()) {
        //        print("Fetching user with uid:", uid)
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            guard let userDictionary = snapshot.value as? [String: Any] else { return }
            let user = User(uid: uid, dictionary: userDictionary)
            completion(user)
        }) { (error: Error) in
            print("Failed to fetch user for posts:", error)
        }
    }
}
