//
//  UserProfileHeader.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class UserProfileHeader: BaseCell {
    
    var user: User? {
        didSet {
            guard let user = user else { return }
            profileImageView.loadImage(urlString: user.profileImgUrl)
            usernameLabel.text = user.username
        }
    }
    
    let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
//        imageView.backgroundColor = .red
//        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let gridButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "grid")
        button.setImage(image, for: .normal)
        return button
    }()
    
    let listButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "list")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let bookmarkButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "ribbon")
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(white: 0, alpha: 0.2)
        return button
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let postLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "11\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "posts", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        // 0 gives however many lines that are necesary.
        label.numberOfLines = 0
        return label
    }()
    
    let followersLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "followers", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let followingLabel: UILabel = {
        let label = UILabel()
        let attributedText = NSMutableAttributedString(string: "0\n", attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: "following", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.lightGray]))
        label.attributedText = attributedText
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Edit Profile", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.layer.borderColor = UIColor.lightGray.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 3
        return button
    }()
    
    override func setupViews() {
        super.setupViews()
        
        setupProfileImage()
        setupBottomToolbar()
        
        addSubview(usernameLabel)
        usernameLabel.anchor(top: profileImageView.bottomAnchor, left: leftAnchor, bottom: gridButton.topAnchor, right: rightAnchor, topConstant: 4, leftConstant: 12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 0)
        
        setupUserStats()
        
        addSubview(editProfileButton)
        editProfileButton.anchor(top: postLabel.bottomAnchor, left: postLabel.leftAnchor, bottom: nil, right: followingLabel.rightAnchor, topConstant: 2, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 34)
    }
    
    fileprivate func setupProfileImage() {
        addSubview(profileImageView)
        let profileImageSize: CGFloat = 80
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: profileImageSize, heightConstant: profileImageSize)
        profileImageView.layer.cornerRadius = profileImageSize / 2
    }
    
    private func setupBottomToolbar() {
        let topDividerView = UIView()
        topDividerView.backgroundColor = UIColor.lightGray
        let bottomDividerView = UIView()
        bottomDividerView.backgroundColor = UIColor.lightGray
        let stackView = UIStackView(arrangedSubviews: [gridButton, listButton, bookmarkButton])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        
        addSubview(stackView)
        addSubview(topDividerView)
        addSubview(bottomDividerView)
        
        stackView.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 50)
        
        topDividerView.anchor(top: stackView.topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        bottomDividerView.anchor(top: stackView.bottomAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    private func setupUserStats() {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: nil, right: rightAnchor, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: -12, widthConstant: 0, heightConstant: 50)
    }
    
}

























