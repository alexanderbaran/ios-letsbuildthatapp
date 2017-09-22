//
//  HomePostCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class HomePostCell: BaseCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let userProfileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.backgroundColor = .red
        return imageView
    }()
    
    let photoImageView: CachedImageView = {
        let imageView = CachedImageView()
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let optionsButton: UIButton = {
        let button = UIButton(type: .system)
        // Search for unicode bullets.
        button.setTitle("•••", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    let likeButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "like_unselected")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()


    let commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()

    let sendMessageButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "send2")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()

    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ribbon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        return button
    }()
    
//    let likeButton = HomePostCell.makeButtonWithImage(imageName: "like_unselected")
//    let commentButton = HomePostCell.makeButtonWithImage(imageName: "comment")
//    let sendMessageButton = HomePostCell.makeButtonWithImage(imageName: "send2")
//    let bookmarkButton = HomePostCell.makeButtonWithImage(imageName: "ribbon")
    
//    fileprivate static func makeButtonWithImage(imageName: String) -> UIButton {
//        let button = UIButton(type: .system)
//        let image = UIImage(named: imageName)?.withRenderingMode(.alwaysOriginal)
//        button.setImage(image, for: .normal)
//        return button
//    }
    
    let captionLabel: UILabel = {
        let label = UILabel()
//        label.text = "Something for now"
        let attributedText = NSMutableAttributedString(string: "Username", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " Some caption text that will perhaps wrap onto the next line.", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        // 4 means new line will have really small font size of 4 giving us a nice small gap.
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
        attributedText.append(NSAttributedString(string: "1 week ago", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
        label.attributedText = attributedText
//        label.backgroundColor = .yellow
        label.numberOfLines = 0 // As many lines as needed.
        return label
    }()
    
    override func setupViews() {
        super.setupViews()
        
//        backgroundColor = .gray
        
        addSubview(userProfileImageView)
        addSubview(usernameLabel)
        addSubview(optionsButton)
        addSubview(photoImageView)
        addSubview(captionLabel)
        
        userProfileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        usernameLabel.anchor(top: userProfileImageView.topAnchor, left: userProfileImageView.rightAnchor, bottom: userProfileImageView.bottomAnchor, right: optionsButton.leftAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        // Apple recommends 44-50 or greater for buttons so you can tap on them with fingers comfortably.
        optionsButton.anchor(top: userProfileImageView.topAnchor, left: nil, bottom: userProfileImageView.bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -8, widthConstant: 44, heightConstant: 0)
        
        photoImageView.anchor(top: userProfileImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 8, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
//        photoImageView.heightAnchor.constraint(equalToConstant: frame.width).isActive = true
        // This is better because it needs to use anchors if it is to render correctly when tilting the screen to landscape mode.
        photoImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 1).isActive = true
        
        setupActionButtons()
        
        // Can't anchor to stackView here because it is not visible on this scope. Also this need to be AFTER setupActionButtons() because we anchor it to likeButton.
        captionLabel.anchor(top: likeButton.bottomAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: -8, widthConstant: 0, heightConstant: 0)
    }
    
    fileprivate func setupActionButtons() {
        let stackView = UIStackView(arrangedSubviews: [likeButton, commentButton, sendMessageButton])
        stackView.distribution = .fillEqually // Almost always fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        addSubview(bookmarkButton)
        stackView.anchor(top: photoImageView.bottomAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 120, heightConstant: 50)
        bookmarkButton.anchor(top: photoImageView.bottomAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 50)
    }
    
}

















