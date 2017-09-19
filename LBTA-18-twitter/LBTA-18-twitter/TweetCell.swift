//
//  TweetCell.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 19/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import LBTAComponents

class TweetCell: DatasourceCell {
    
    override var datasourceItem: Any? {
        didSet {
            guard let tweet = datasourceItem as? Tweet else { return }
//            messageTextView.text = tweet.message
            
            let nameAttributes = [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 16)]
            let attributedText = NSMutableAttributedString(string: tweet.user.name, attributes: nameAttributes)
            
            let usernameString = "  \(tweet.user.username)"
            let usernameAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 15),
                NSForegroundColorAttributeName: UIColor.gray
            ]
            attributedText.append(NSAttributedString(string: usernameString, attributes: usernameAttributes))
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            let range = NSMakeRange(0, attributedText.string.characters.count)
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            
            let messageString = "\n\(tweet.message)"
            let messageAttributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
            attributedText.append(NSAttributedString(string: messageString, attributes: messageAttributes))
            
            messageTextView.attributedText = attributedText
        }
    }
    
    /* Why are we using a text view instead of a label? The reason is because the formatting of the text view starts the text at the very top and for the label it vertically aligns everything inside of the center. */
    let messageTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Some sample text."
//        textView.backgroundColor = .yellow
        textView.backgroundColor = .clear
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_image")
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let replyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "reply")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let retweetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "retweet")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "like")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    let directMessageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "send_message")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        backgroundColor = .white
        
        separatorLineView.isHidden = false
        separatorLineView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        addSubview(profileImageView)
        addSubview(messageTextView)
        
        profileImageView.anchor(topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        
        messageTextView.anchor(topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)

        setupBottomButtons()
    }
    
    fileprivate func setupBottomButtons() {
        
        let replyButtonContainerView = UIView()
//        replyButtonContainerView.backgroundColor = .red
        let retweetButtonContainerView = UIView()
//        retweetButtonContainerView.backgroundColor = .blue
        let likeButtonContainerView = UIView()
//        likeButtonContainerView.backgroundColor = .green
        let directMessageButtonContainerView = UIView()
//        directMessageButtonContainerView.backgroundColor = .purple
        let buttonStackView = UIStackView(arrangedSubviews: [replyButtonContainerView, retweetButtonContainerView, likeButtonContainerView, directMessageButtonContainerView])
        buttonStackView.axis = .horizontal
        buttonStackView.distribution = .fillEqually
        
        addSubview(buttonStackView)
        addSubview(replyButton)
        addSubview(retweetButton)
        addSubview(likeButton)
        addSubview(directMessageButton)
        
        buttonStackView.anchor(nil, left: messageTextView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 4, rightConstant: 0, widthConstant: 0, heightConstant: 20)
        
        replyButton.anchor(replyButtonContainerView.topAnchor, left: replyButtonContainerView.leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 20)
        
        retweetButton.anchor(retweetButtonContainerView.topAnchor, left: retweetButtonContainerView.leftAnchor, bottom: retweetButtonContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 0)
        
        likeButton.anchor(likeButtonContainerView.topAnchor, left: likeButtonContainerView.leftAnchor, bottom: likeButtonContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 0)
        
        directMessageButton.anchor(directMessageButtonContainerView.topAnchor, left: directMessageButtonContainerView.leftAnchor, bottom: directMessageButtonContainerView.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 20, heightConstant: 0)
    }
}












