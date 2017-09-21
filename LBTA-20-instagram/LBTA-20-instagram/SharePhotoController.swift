//
//  SharePhotoController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class SharePhotoController: UIViewController {
    
    var selectedImage: UIImage? {
        didSet {
            self.imageView.image = selectedImage
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Background color of a a view controller is by default black.
        view.backgroundColor = UIColor.rgb(red: 240, green: 240, blue: 240)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: .plain, target: self, action: #selector(handleShare))
        
        setupImageAndTextViews()
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
//        iv.backgroundColor = .red
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()
    
    /* We use UITextView instead of UITextField because multiple lines. */
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 14)
        return tv
    }()
    
    fileprivate func setupImageAndTextViews() {
        let containerView = UIView()
        containerView.backgroundColor = .white
        view.addSubview(containerView)
        // We can't use view.topAnchor here because it goes behind the navigation bar and all the way to the top.
        // topLayoutGuide indicates the highest vertical extent for you onscreen content for use with autolayout constraints.
        containerView.anchor(top: topLayoutGuide.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 100)
        
        containerView.addSubview(imageView)
        // 84 because 100 - 8 - 8
        imageView.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: containerView.bottomAnchor, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: -8, rightConstant: 0, widthConstant: 84, heightConstant: 0)
        
        containerView.addSubview(textView)
        textView.anchor(top: containerView.topAnchor, left: imageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, topConstant: 0, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    func handleShare() {
        guard let caption = textView.text, caption != "" else { return }
        guard let image = selectedImage else { return }
        // Disable button to prevent duplicate sent requests.
        navigationItem.rightBarButtonItem?.isEnabled = false
        let filename = UUID().uuidString
        guard let uploadData = UIImageJPEGRepresentation(image, 0.5) else { return }
        Storage.storage().reference().child("posts_images").child(filename).putData(uploadData, metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
            if error != nil {
                print("Failed to upload post image:", error!)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            guard let imageUrl = metadata?.downloadURL()?.absoluteString else { return }
            print("Successfully uploaded post image:", imageUrl)
            self.saveToDatabaseWithImageUrl(imageUrl: imageUrl, caption: caption, postImage: image)
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    fileprivate func saveToDatabaseWithImageUrl(imageUrl: String, caption: String, postImage: UIImage) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userPostRef = Database.database().reference().child("posts").child(uid)
        // childByAutoId generates a new child location using a unique key and returns a firebase database reference to it.
        let ref = userPostRef.childByAutoId()
        let values: [String: Any] = ["imageUrl": imageUrl, "caption": caption, "imageWidth": postImage.size.width, "imageHeight": postImage.size.height, "creationDate": Date().timeIntervalSince1970]
        ref.updateChildValues(values) { (error: Error?, reference: DatabaseReference) in
            if error != nil {
                print("Failed to save post to DB", error!)
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                return
            }
            print("Successfully saved post to DB")
            self.dismiss(animated: true, completion: nil)
        }
    }
}


























