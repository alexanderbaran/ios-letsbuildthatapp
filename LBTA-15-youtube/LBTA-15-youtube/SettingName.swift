//
//  SettingName.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 12/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation

enum SettingName: String {
    case settings = "Settings"
    case termsPrivacy = "Terms & privacy policy"
    case sendFeedback = "Send Feedback"
    case help = "help"
    case switchAccount = "Switch Account"
    // We can change the string and things will stil work when clicking Cancel & Dismiss because we are using enums.
//    case cancel = "Cancel & Dismiss"
    case cancel = "Cancel"
}
