//
//  ViewController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

let disabledBlue = UIColor.rgb(red: 149, green: 204, blue: 244)
let activeBlue = UIColor.rgb(red: 17, green: 154, blue: 237 )

class SignUpController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
//        button.backgroundColor = .red
        let image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)
        button.tintColor = activeBlue
//        let image = UIImage(named: "plus_photo")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePlusPhoto), for: .touchUpInside)
        return button
    }()
    
    func handlePlusPhoto() {
        /* App crashed with crytic message. Need to add to Info.plist. The app requires aditional permissions to
         access the photos on our device. Privacy - Photo Library Usage Description: We'd like access to your photos right now, make sure
         you are clear when you ask and don't sound too creepy. */
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var image: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            image = originalImage
        }
//        print(originalImage?.size, editedImage?.size)
        image = image?.withRenderingMode(.alwaysOriginal)
        plusPhotoButton.setImage(image, for: .normal)
        plusPhotoButton.layer.cornerRadius = plusPhotoButton.frame.width / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.black.cgColor
        plusPhotoButton.layer.borderWidth = 2
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
        handleTextInputChange()
    }
    
    lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.keyboardType = .emailAddress
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    func handleTextInputChange() {
        let isEmailValid = emailTextField.text?.characters.count ?? 0 > 0
        let isUsernameValid = usernameTextField.text?.characters.count ?? 0 > 0
        let isPasswordValid = passwordTextField.text?.characters.count ?? 0 >= 6
        let imageValid = !(plusPhotoButton.currentImage?.isEqual(UIImage(named: "plus_photo")?.withRenderingMode(.alwaysTemplate)))!
        let isFormValid = isEmailValid && isUsernameValid && isPasswordValid && imageValid
        if isFormValid {
            signUpButton.backgroundColor = activeBlue
            signUpButton.isEnabled = true
        } else {
            signUpButton.backgroundColor = disabledBlue
            signUpButton.isEnabled = false
        }
    }
    
    let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Username"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = UIColor(white: 0, alpha: 0.03)
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.addTarget(self, action: #selector(handleTextInputChange), for: .editingChanged)
        textField.isSecureTextEntry = true
        return textField
    }()
    
    lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = disabledBlue
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    lazy var alreadyHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedText = NSMutableAttributedString(string: "Already have an account? ", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray])
        attributedText.append(NSAttributedString(string: "Sign In", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14), NSForegroundColorAttributeName: activeBlue]))
        button.setAttributedTitle(attributedText, for: .normal)
        button.addTarget(self, action: #selector(handleAlreadyHaveAccount), for: .touchUpInside)
        return button
    }()
    
    func handleAlreadyHaveAccount() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    func handleSignUp() {
        guard let email = emailTextField.text, email != "" else { return }
        guard let username = usernameTextField.text, username != "" else { return }
        guard let password = passwordTextField.text, password.characters.count >= 6 else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error: Error?) in
            if error != nil {
                print("Failed to create user:", error!)
                return
            }
            print("Successfully created user:", user?.uid ?? "")
            guard let image = self.plusPhotoButton.imageView?.image else { return }
            guard let uploadData = UIImageJPEGRepresentation(image, 0.3) else { return }
            let filename = UUID().uuidString
            Storage.storage().reference().child("profile_images").child(filename).putData(uploadData, metadata: nil, completion: { (metadata: StorageMetadata?, error: Error?) in
                if error != nil {
                    print("Failed to upload profile image:", error!)
                    return
                }
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else { return }
                print("Successfully uploaded profile image:", profileImageUrl)
                guard let uid = user?.uid else { return }
                let dictionaryValues = ["username": username, "profileImageUrl": profileImageUrl]
                let values = [uid: dictionaryValues]
                Database.database().reference().child("users").updateChildValues(values, withCompletionBlock: { (error: Error?, reference: DatabaseReference) in
                    if error != nil {
                        print("Failed to save user info into db:", error!)
                        return
                    }
                    print("Successfully saved user info to db.")
                    // rootViewController here is the MainTabBarController because we set it in AppDelegate.swift
                    guard let mainTabBarController = UIApplication.shared.keyWindow?.rootViewController as? MainTabBarController else { return }
                    mainTabBarController.setupViewControllers()
                    self.dismiss(animated: true, completion: nil)
                })
            })
//            let values = ["username": username]
//            Database.database().reference().child("users").child(uid).setValue(values, withCompletionBlock: { (error: Error?, reference: DatabaseReference) in
//                if error != nil {
//                    print("Failed to save user info into db:", error!)
//                    return
//                }
//                print("Successfully saved user info to db.")
//            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* SignUpController had a black background because we constructed a UIViewController with a default constuctor without storyboard. */
        view.backgroundColor = .white
        
        view.addSubview(plusPhotoButton)
        view.addSubview(emailTextField)
        
        setupInputFields()
        
        plusPhotoButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 40, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 140, heightConstant: 140)
        plusPhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(alreadyHaveAccountButton)
        alreadyHaveAccountButton.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
    }
    
    fileprivate func setupInputFields() {
        let stackView = UIStackView(arrangedSubviews: [emailTextField, usernameTextField, passwordTextField, signUpButton])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fillEqually
        view.addSubview(stackView)
//        NSLayoutConstraint.activate([
//            stackView.topAnchor.constraint(equalTo: plusPhotoButton.bottomAnchor, constant: 20),
//            stackView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40),
//            stackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40),
//            stackView.heightAnchor.constraint(equalToConstant: 200)
//        ])
        stackView.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 20, leftConstant: 40, bottomConstant: 0, rightConstant: -40, widthConstant: 0, heightConstant: 190)
    }

}



















