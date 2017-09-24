//
//  CommentsController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 24/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    private let commentCellId = "commentCellId"
    
    var post: Post?
    
    lazy var keyboardInputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Comment"
        textField.delegate = self
        return textField
    }()
    
    // https://stackoverflow.com/questions/34980391/entering-text-into-ui-textfield-by-pressing-return-button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSubmit()
        return true
    }
    
    let keyboardInputContainerSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    lazy var submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    func handleSubmit() {
        // Make sure the submitButton is not below the UITextField.
        guard let text = keyboardInputTextField.text, !text.isEmpty else { return }
        guard let postId = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error: Error?, reference: DatabaseReference) in
            if error != nil {
                print("Failed to insert comment:", error!)
                return
            }
            print("Successfully inserted comment.")
            self.keyboardInputTextField.text = nil
        }
    }
    
    // This needs to be referenceable outside of inputAccessoryView getter in order for the textfield to be typeable.
    lazy var keyboardInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        view.addSubview(self.keyboardInputTextField)
        view.addSubview(self.keyboardInputContainerSeparator)
        view.addSubview(self.submitButton)
        self.keyboardInputTextField.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: self.submitButton.leftAnchor, topConstant: 0, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        self.keyboardInputContainerSeparator.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        self.submitButton.anchor(top: view.topAnchor, left: nil, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 50, heightConstant: 0)
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
        navigationItem.title = "Comments"
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        // keyboardDismissMode needs alwaysBounceVertical to be true
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.register(CommentCell.self, forCellWithReuseIdentifier: commentCellId)
        // There might be some spacing problems at the bottom where the inputAccessoryView is. Make sure to return many cells in the beginning to see how the collectionView behaves with the inputAccessoryView.
//        collectionView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: -50, right: 0)
        fetchComments()
    }
    
    var comments = [Comment]()
    
    private func fetchComments() {
        guard let postId = post?.id else { return }
        Database.database().reference().child("comments").child(postId).observe(.childAdded, with: { (snapshot) in
            // This block runs multiple times. Once for ever child. And every time new child is added. It is observing until cancelled.
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            Database.fetchUserWithUID(uid: uid, completion: { (user) in
                var comment = Comment(dictionary: dictionary)
                comment.user = user
                self.comments.append(comment)
                self.collectionView?.reloadData()
            })
        }) { (error) in
            print("Failed to observe comments:", error)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return comments.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: commentCellId, for: indexPath) as! CommentCell
        cell.comment = comments[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let comment = comments[indexPath.item]
//        guard let user = comment.user else { return CGSize.zero }
//        let text = CommentCell.attributedText(username: user.username, text: comment.text)
//        let width: CGFloat = view.frame.width - 40 - 8 - 8 - 8
//        let size = CGSize(width: width, height: 1000)
//        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
//        let boundingRect = text.boundingRect(with: size, options: options, context: nil)
//        let minimumHeight: CGFloat = 40 + 8 + 8
//        var height: CGFloat = 4 + boundingRect.height + 20
//        if height < minimumHeight {
//            height = minimumHeight
//        }
//        return CGSize(width: view.frame.width, height: height)
        
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let dummyCell = CommentCell(frame: frame)
        dummyCell.comment = comments[indexPath.item]
        // Need to call layoutIfNeeded after we set the comment.
        dummyCell.layoutIfNeeded()
        // There is a method on each one of these UIView objects and cell objects called systemLayoutSizeFitting.
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = dummyCell.systemLayoutSizeFitting(targetSize)
        let height = max(40 + 8 + 8, estimatedSize.height)
        return CGSize(width: view.frame.width, height: height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}




















