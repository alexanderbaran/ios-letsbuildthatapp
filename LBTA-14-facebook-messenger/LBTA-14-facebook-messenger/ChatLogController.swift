//
//  ChatLogController.swift
//  LBTA-14-facebook-messenger
//
//  Created by Alexander Baran on 10/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let chatLogMessageCellId = "chatLogMessageCellId"
    
    var friend: Friend? {
        didSet {
            navigationItem.title = friend?.name
            // messages here is an NSSet?
            messages = friend?.messages?.allObjects as? [Message]
            
            messages = messages?.sorted(by: { (message1: Message, message2: Message) -> Bool in
                return message1.date!.compare(message2.date! as Date) == .orderedAscending
            })
        }
    }
    
    var messages: [Message]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tabBarController?.tabBar.isHidden = true
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: chatLogMessageCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = messages?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatLogMessageCellId, for: indexPath) as! ChatLogMessageCell
//        if let message = messages?[indexPath.item] {
//            cell.message = message
//        }
        cell.messageTextView.text = messages?[indexPath.item].text
        
        if let profileImageName = messages?[indexPath.item].friend?.profileImageName {
            cell.profileImageView.image = UIImage(named: profileImageName)
        }
        
        if let message = messages?[indexPath.item], let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            
            if !message.isSender {
                // Added another 16 to the width so that text is not cut at the bottom.
                cell.messageTextView.frame = CGRect(x: 48 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 20)
                cell.textBubbleView.frame = CGRect(x: 48 - 10, y: -4, width: estimatedFrame.width + 16 + 8 + 16, height: estimatedFrame.height + 20 + 6)
//                cell.profileImageView.isHidden = false
//                cell.textBubbleView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//                cell.messageTextView.textColor = UIColor.black
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
        if let messageText = messages?[indexPath.item].text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 18)]
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: attributes, context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 20)
        }
        return CGSize(width: view.frame.width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 16, left: 0, bottom: 16, right: 0)
    }
}







