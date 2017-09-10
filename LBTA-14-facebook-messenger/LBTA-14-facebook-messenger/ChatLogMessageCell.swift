//
//  ChatLogMessageCell.swift
//  LBTA-14-facebook-messenger
//
//  Created by Alexander Baran on 10/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ChatLogMessageCell: BaseCell {
    
//    var message: Message? {
//        didSet {
//            
//        }
//    }
    
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.backgroundColor = UIColor.clear
        return textView
    }()
    
    let textBubbleView: UIView = {
        let view = UIView()
//        view.backgroundColor = UIColor(white: 0.95, alpha: 1)
        view.layer.cornerRadius = 15
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 15
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    // Check video for more explanation here. Is uses the corners and then stretches/fills the rest of the image.
    static let grayBubbleImage = UIImage(named: "bubble_gray")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    static let blueBubbleImage = UIImage(named: "bubble_blue")!.resizableImage(withCapInsets: UIEdgeInsets(top: 22, left: 26, bottom: 22, right: 26)).withRenderingMode(.alwaysTemplate)
    
    let bubbleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = ChatLogMessageCell.grayBubbleImage
        // If we set the renderingMode above, we can set the tintColor
        imageView.tintColor = UIColor(white: 0.95, alpha: 1)
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
//        backgroundColor = UIColor.lightGray
        
        addSubview(textBubbleView)
        addSubview(messageTextView)
        addSubview(profileImageView)
        
        addConstraintsWithFormat(format: "H:|-8-[v0(30)]", views: profileImageView)
        addConstraintsWithFormat(format: "V:[v0(30)]|", views: profileImageView)
//        profileImageView.backgroundColor = UIColor.red
        
//        addConstraintsWithFormat(format: "H:|[v0]|", views: messageTextView)
//        addConstraintsWithFormat(format: "V:|[v0]|", views: messageTextView)
        
        textBubbleView.addSubview(bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "H:|[v0]|", views: bubbleImageView)
        textBubbleView.addConstraintsWithFormat(format: "V:|[v0]|", views: bubbleImageView)
    }
}









