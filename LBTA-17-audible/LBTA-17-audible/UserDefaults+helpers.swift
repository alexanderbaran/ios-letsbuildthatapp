//
//  UserDefaults+helpers.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

//fileprivate let isLoggedInKey = "isLoggedIn"

extension UserDefaults {
    enum UserDefaultsKeys: String {
        case isLoggedIn
    }
    func setIsLoggedIn(value: Bool) {
        set(value, forKey: UserDefaultsKeys.isLoggedIn.rawValue)
        synchronize()
    }
    func isLoggedIn() -> Bool {
        return bool(forKey: UserDefaultsKeys.isLoggedIn.rawValue)
    }
}
