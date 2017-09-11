//
//  ChatLogController.swift
//  LBTA-14-facebook-messenger
//
//  Created by Alexander Baran on 10/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import CoreData

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate {
    
    private let chatLogMessageCellId = "chatLogMessageCellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            // messages here is an NSSet?
//            messages = friend?.messages?.allObjects as? [Message]
//            
//            messages = messages?.sorted(by: { (message1: Message, message2: Message) -> Bool in
//                return message1.date!.compare(message2.date! as Date) == .orderedAscending
//            })
        }
    }
    
//    var messages: [Message]?
    
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        return textField
    }()
    
    // Must use lazy var because of self keyword. Makes self available.
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor.rgb(red: 0, green: 137, blue: 249)
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    // Can't be private func, because used in #selector above.
    func handleSend() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
//        let message = FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
        _ = FriendsController.createMessageWithText(text: inputTextField.text!, friend: friend!, minutesAgo: 0, context: context, isSender: true)
        do {
            try context.save()
        } catch let error {
            print(error)
        }
//        messages?.append(message)
//        let item = messages!.count - 1
//        let insertionIndexPath = IndexPath(item: item, section: 0)
//        collectionView?.insertItems(at: [insertionIndexPath])
////        collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: true)
//        collectionView?.scrollToItem(at: insertionIndexPath, at: .bottom, animated: false)
        inputTextField.text = nil
    }
    
    var bottomConstraint: NSLayoutConstraint?
    
    func simulate() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
//        let message = FriendsController.createMessageWithText(text: "Here's a text message that was sent a few minutes ago...", friend: friend!, minutesAgo: 1, context: context)
        // Putting two objects at the same time will make it crash, so we need to use BlockOperation.
        _ = FriendsController.createMessageWithText(text: "Here's a text message that was sent a few minutes ago...", friend: friend!, minutesAgo: 1, context: context)
        _ = FriendsController.createMessageWithText(text: "Another message that was received a while ago...", friend: friend!, minutesAgo: 1, context: context)
        do {
            try context.save()
        } catch let error {
            print(error)
        }
//        messages?.append(message)
//        messages = messages?.sorted(by: { $0.date!.compare($1.date! as Date) == .orderedAscending })
//        if let item = messages?.index(of: message) {
//            let receivingIndexPath = IndexPath(item: item, section: 0)
//            collectionView?.insertItems(at: [receivingIndexPath])
//        }
        
    }
    
    // Must be lazy var because of self.friend!.name! and self.
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        fetchRequest.predicate = NSPredicate(format: "friend.name = %@", self.friend!.name!)
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    var blockOperations = [BlockOperation]()
    
    /* Everytime a new object is inserted into core data, this method is called. */
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            // Need this if we put more than one object at the same time.
            blockOperations.append(BlockOperation(block: { 
                self.collectionView?.insertItems(at: [newIndexPath!])
            }))
            
            // More than one messages and you don't know which index to scroll to.
//            collectionView?.scrollToItem(at: newIndexPath!, at: .bottom, animated: false)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.performBatchUpdates({ 
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: { (completed: Bool) in
            let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
            let indexPath = IndexPath(item: lastItem, section: 0)
            self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
        })
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        do {
            try fetchedResultsController.performFetch()
//            print(fetchedResultsController.sections?.count)
//            print(fetchedResultsController.sections?[0].numberOfObjects)
        } catch let error {
            print(error)
        }
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Simulate", style: .plain, target: self, action: #selector(simulate))
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: chatLogMessageCellId)
        
        view.addSubview(messageInputContainerView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: messageInputContainerView)
        view.addConstraintsWithFormat(format: "V:[v0(48)]", views: messageInputContainerView)
        
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint!)
        
        setupInputComponents()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: .UIKeyboardWillHide, object: nil)
    }
    
    func handleKeyboardNotification(notification: Notification) {
        if let userInfo = notification.userInfo {
            // https://stackoverflow.com/questions/25451001/getting-keyboard-size-from-userinfo-in-swift
            let keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect
            
            let isKeyboardShowing = notification.name == NSNotification.Name.UIKeyboardWillShow
            
            bottomConstraint?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            
            UIView.animate(withDuration: 0, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: {
                // Once you change this constraint above, if we call layoutIfNeeded, it will just to the animation for us.
                self.view.layoutIfNeeded()
            }, completion: { (completed: Bool) in
                // Only animate when keyboard is showing. Coz it did not look good the other way around.
                if isKeyboardShowing {
//                    let indexPath = IndexPath(item: self.messages!.count - 1, section: 0)
//                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: true)
                    
                    let lastItem = self.fetchedResultsController.sections![0].numberOfObjects - 1
                    let indexPath = IndexPath(item: lastItem, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
                }
            })
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // This is supposed to dismiss the keyboard. But only if you tap the cell and not the bubble for now.
        inputTextField.endEditing(true)
    }
    
    private func setupInputComponents() {
        
        let topBorderView = UIView()
        topBorderView.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        
        messageInputContainerView.addSubview(inputTextField)
        messageInputContainerView.addSubview(sendButton)
        messageInputContainerView.addSubview(topBorderView)
        
        messageInputContainerView.addConstraintsWithFormat(format: "H:|-8-[v0][v1(60)]|", views: inputTextField, sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "H:|[v0]|", views: topBorderView)
        
        
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: inputTextField)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0]|", views: sendButton)
        messageInputContainerView.addConstraintsWithFormat(format: "V:|[v0(0.5)]", views: topBorderView)
        
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        if let count = messages?.count {
//            return count
//        }
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatLogMessageCellId, for: indexPath) as! ChatLogMessageCell
//        if let message = messages?[indexPath.item] {
//            cell.message = message
//        }
        
        let message = fetchedResultsController.object(at: indexPath) as Message
        
//        cell.messageTextView.text = messages?[indexPath.item].text
        cell.messageTextView.text = message.text
        
//        if let profileImageName = messages?[indexPath.item].friend?.profileImageName {
        if let profileImageName = message.friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
        }
        
//        if let message = messages?[indexPath.item], let messageText = message.text {
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            
            if !message.isSender {
                // Added another 16 to the width so that text is not cut at the bottom.
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
                
                
                // We actually need to set these here too because or else it bugged when inserting mulitple with simulate button.
                cell.profileImageView.isHidden = false
//                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
                cell.bubbleImageView.tintColor = UIColor(white: 0.95, alpha: 1)
                cell.messageTextView.textColor = UIColor.black
                cell.bubbleImageView.image = ChatLogMessageCell.grayBubbleImage
                
            } else {
                // Added another 16 to the width so that text is not cut at the bottom.
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 16 - 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 16 - 8 - 16 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 10, height: estimatedFrame.height + 20 + 6)
                
                cell.profileImageView.isHidden = true
//                cell.textBubbleView.backgroundColor = UIColor.rgb(red: 0, green: 137, blue: 249)
                cell.bubbleImageView.tintColor = UIColor.rgb(red: 0, green: 137, blue: 249)
                cell.messageTextView.textColor = UIColor.white
                cell.bubbleImageView.image = ChatLogMessageCell.blueBubbleImage
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let message = fetchedResultsController.object(at: indexPath) as Message
//        if let messageText = messages?[indexPath.item].text {
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 12, left: 0, bottom: 8, right: 0)
    }
}







