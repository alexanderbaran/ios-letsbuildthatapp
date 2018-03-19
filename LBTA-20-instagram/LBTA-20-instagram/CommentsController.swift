//
//  CommentsController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 24/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class CommentsController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CommentInputAccessoryViewDelegate {
    
    private let commentCellId = "commentCellId"
    
    var post: Post?
    
    func didSubmit(for comment: String?) {
        // Make sure the submitButton is not below the UITextField.
        //        guard let text = keyboardInputTextField.text, !text.isEmpty else { return }
        //        guard let text = keyboardInputContainerView.textField.text, !text.isEmpty else { return }
        guard let text = comment, !text.isEmpty else { return }
        guard let postId = post?.id else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let values = ["text": text, "creationDate": Date().timeIntervalSince1970, "uid": uid] as [String: Any]
        Database.database().reference().child("comments").child(postId).childByAutoId().updateChildValues(values) { (error: Error?, reference: DatabaseReference) in
            if error != nil {
                print("Failed to insert comment:", error!)
                return
            }
            print("Successfully inserted comment.")
//            self.keyboardInputContainerView.textField.text = nil
            self.commentInputContainerView.clearCommentText()
        }
    }
    
    // This needs to be referenceable outside of inputAccessoryView getter in order for the textfield to be typeable.
//    lazy var commentInputContainerView: CommentInputAccessoryView = { [weak self] in
//        guard let object = self else { return CommentInputAccessoryView() }
//        let frame = CGRect(x: 0, y: 0, width: object.view.frame.width, height: 50)
//        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
//        commentInputAccessoryView.delegate = object
//        return commentInputAccessoryView
//    }()
    
    // Classes are not being deinitialized. Might possibly lead to memory leak.
    lazy var commentInputContainerView: CommentInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let commentInputAccessoryView = CommentInputAccessoryView(frame: frame)
        commentInputAccessoryView.delegate = self
        return commentInputAccessoryView
    }()

//    let commentInputContainerView: CommentInputAccessoryView = {
//        return CommentInputAccessoryView()
//    }()
    
    override var inputAccessoryView: UIView? {
        return commentInputContainerView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        super.init(collectionViewLayout: layout)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CommentsController deinit")
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




















