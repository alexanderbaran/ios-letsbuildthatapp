//
//  CommentsController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 24/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class CommentsController: UICollectionViewController {
    
    let keyboardInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        return textField
    }()
    
    let keyboardInputContainerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    lazy var keyboardInputContainerView: UIView = {
        let view = UIView()
//        view.backgroundColor = .red
        view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        view.addSubview(self.keyboardInputTextField)
        self.keyboardInputTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        view.addSubview(self.keyboardInputContainerSeparator)
        self.keyboardInputContainerSeparator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        return view
    }()
    
    override var inputAccessoryView: UIView? {
        return keyboardInputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

}
