//
//  LeftPaddedTextField.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class LeftPaddedTextField: UITextField {
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x + 10, y: bounds.origin.y, width: bounds.width + 10, height: bounds.height)
    }
    
}
