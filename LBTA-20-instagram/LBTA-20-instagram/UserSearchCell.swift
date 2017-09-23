//
//  UserSearchCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class UserSearchCell: BaseCell {
    
    var user: User? {
        didSet {
            guard let user = self.user else { return }
            profileImageView.loadImage(urlString: user.profileImgUrl)
            usernameLabel.text = user.username
        }
    }
    
    let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
//        imageView.backgroundColor = .red
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 25
        return imageView
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
//        backgroundColor = .yellow
        
        addSubview(profileImageView)
        addSubview(usernameLabel)
        addSubview(separatorView)
        
        profileImageView.anchor(top: nil, left: leftAnchor, bottom: nil, right: nil, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        usernameLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        separatorView.anchor(top: nil, left: usernameLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
}










