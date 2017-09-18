//
//  LoginCell.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class LoginCell: BaseCell {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        return imageView
    }()
    
    private static let cornerRadius: CGFloat = 3
    private static let borderColor = UIColor(white: 0.85, alpha: 1).cgColor
    
    let emailTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter email"
//        textField.borderStyle = .line
        textField.layer.borderColor = LoginCell.borderColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = LoginCell.cornerRadius
        textField.keyboardType = .emailAddress
        return textField
    }()
    
    let passwordTextField: LeftPaddedTextField = {
        let textField = LeftPaddedTextField()
        textField.placeholder = "Enter password"
        //        textField.borderStyle = .line
        textField.layer.borderColor = LoginCell.borderColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = LoginCell.cornerRadius
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = CustomColor.orange
        button.setTitle("Log in", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = LoginCell.cornerRadius
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    /* Watch out for retain cycles. LoginCell knows about LoginController and LoginController knows about the LoginCell. Both of these components point to each
     other right now and so we have this retain cycle. We can't perform weak like this because delegates need to be specified as class instead of just a plain
     old protocol. */
//    var loginController: LoginController?
    
    weak var delegate: LoginControllerDelegate?
    
    func handleLogin() {
//        loginController?.finishLoggingIn()
        delegate?.finishLoggingIn()
    }
    
    override func setupViews() {
//        backgroundColor = .red
        addSubview(logoImageView)
        addSubview(emailTextField)
        addSubview(passwordTextField)
        addSubview(loginButton)
        
        _ = logoImageView.anchor(centerYAnchor, left: nil, bottom: nil, right: nil, topConstant: -230, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 160, heightConstant: 160)
        logoImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        _ = emailTextField.anchor(logoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 50)
        
        _ = passwordTextField.anchor(emailTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 50)
        
        _ = loginButton.anchor(passwordTextField.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 16, leftConstant: 32, bottomConstant: 0, rightConstant: -32, widthConstant: 0, heightConstant: 50)
    }
    
}











