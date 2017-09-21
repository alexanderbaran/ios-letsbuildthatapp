//
//  LoginController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    let logoContainerView: UIView = {
        let view = UIView()
        let logoImageView = UIImageView(image: UIImage(named: "Instagram_logo_white"))
//        logoImageView.backgroundColor = .red
        logoImageView.contentMode = .scaleAspectFill
        view.addSubview(logoImageView)
        logoImageView.anchor(top: nil, left: nil, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 200, heightConstant: 50)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        view.backgroundColor = UIColor.rgb(red: 0, green: 120, blue: 175)
        return view
    }()
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        //        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .emailAddress
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        //        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
//        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.backgroundColor = disabledBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
//        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Don't have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: "Sign Up", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: activeBlue]))
        button.setAttributedTitle(attributedText, for: .normal)
//        button.setTitle("Don't have an account? Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    
    func handleShowSignUp() {
        let signUpController = SignUpController()
//        print(navigationController) // navigationController is nil
        /* For some reason the tutorial wanted to pushViewController on navigationController instead of just present. To use navigationController first need to set a UINavigationController in MainTabBarController. */
        navigationController?.pushViewController(signUpController, animated: true)
//        present(signUpController, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(logoContainerView)
        logoContainerView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 150)
        
        navigationController?.isNavigationBarHidden = true
        
        view.backgroundColor = .white
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        setupInputFields()
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, passwordTextField, loginButton])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
        stackView.anchor(top: logoContainerView.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 40, leftConstant: 40, bottomConstant: 0, rightConstant: -40, widthConstant: 0, heightConstant: 140)
    }
    
}















