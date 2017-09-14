//
//  LoginController+handlers.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 13/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImageView() {
        // https://stackoverflow.com/questions/41663249/uiimagepickercontroller-throwing-sigabrt
        let picker = UIImagePickerController()
        
        // Need to add UINavigationControllerDelegate as protocol.
        picker.delegate = self
        // Makes it possible to crop image.
        // Tip: Put breakpoint on print(info), right click on info and Print Description of "info" to see what you need to get the cropped image.
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        /* Tip: Put breakpoint on print(info), right click on info and Print Description of "info". If you crop the image we have to do this to see where to get the image and its crop rect. */
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
            // Have to set mask masksToBounds again for some weird reason.
            profileImageView.layer.masksToBounds = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
//        print("cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func handleRegister() {
        
        if (profileImageView.image?.isEqual(UIImage(named: "circle_plus")?.withRenderingMode(.alwaysTemplate)))! {
            print("Choose a profile image.")
            return
        }
        
        // Guard statesments are really useful for forms and form validations.
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Form is not valid.")
            return
        }
        // https://firebase.google.com/docs/auth/ios/start
        Auth.auth().createUser(withEmail: email, password: password) { (user: User?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            // Successfully authenticated user.
            // Save user.
            guard let uid = user?.uid else {
                return
            }
            let imageName = UUID().uuidString
            // profile_images is the directory name
//            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
//            // Images are too big with UIImagePNGRepresentation.
//            guard let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) else {
//                return
//            }
            // 0.1 is 10% of the quality.
            guard let profileImage = self.profileImageView.image, let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) else {
                return
            }
            storageRef.putData(uploadData, metadata: nil, completion: { (metadata: StorageMetadata?, error: Error?) in
                if error != nil {
                    print(error!)
                    return
                }
                // If you put a breakpoint to print(metadata), you can type in: po metadata?.downloadURL() in console. po stands for "print object".
//                print(metadata)
                guard let profileImageUrl = metadata?.downloadURL()?.absoluteString else {
                    return
                }
                let values = ["name": name, "email": email, "profileImageUrl": profileImageUrl]
                self.registerUserIntoDatabaseWithUID(uid: uid, values: values)
            })
        }
    }
    
    private func registerUserIntoDatabaseWithUID(uid: String, values: [String: Any]) {
//        self.ref = Database.database().reference(fromURL: "https://lbta-16-firebase-chat.firebaseio.com/")
        let ref = Database.database().reference()
        let usersReference = ref.child("users").child(uid)
//        let values = ["name": name, "email": email, "profileImageUrl": metadata.downloadURL()]
        // Should, or have to name the error something else than the one above.
        usersReference.updateChildValues(values, withCompletionBlock: { (errorUpdate: Error?, reference: DatabaseReference) in
            if errorUpdate != nil {
                print(errorUpdate!)
                return
            }
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
//            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = ChatUser()
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)
            // Saved user successfully into Firebase DB.
            self.dismiss(animated: true, completion: nil)
        })
    }
}







