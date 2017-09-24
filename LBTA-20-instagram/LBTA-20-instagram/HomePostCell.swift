//
//  HomePostCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

// Delegate naming convention.
protocol HomePostCellDelegate {
    func didTapComment(post: Post)
}

class HomePostCell: BaseCell {
    
    // Needs to be an optional.
    var delegate: HomePostCellDelegate?
    
    var post: Post? {
        didSet {
            guard let post = post else { return }
            photoImageView.loadImage(urlString: post.imageUrl)
            usernameLabel.text = post.user.username
            userProfileImageView.loadImage(urlString: post.user.profileImgUrl)
            captionLabel.attributedText = attributedTextForCaptionLabel(username: post.user.username, caption: post.caption, date: post.creationDate)
        }
    }
    
    let userProfileImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
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

    lazy var commentButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "comment")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleComment), for: .touchUpInside)
        return button
    }()

    func handleComment() {
        // Custom delegation is needed.
        guard let post = self.post else { return }
        delegate?.didTapComment(post: post)
    }
    
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
        label.numberOfLines = 0 // As many lines as needed.
        return label
    }()
    
    // https://stackoverflow.com/questions/39027250/what-is-a-good-example-to-differentiate-between-fileprivate-and-private-in-swift
    // Seems like this changed in Swift 4
    private func attributedTextForCaptionLabel(username: String, caption: String, date: Date) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(caption)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        // 4 means new line will have really small font size of 4 giving us a nice small gap.
        attributedText.append(NSAttributedString(string: "\n\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 4)]))
        
        let timeAgoDisplay = date.timeAgoDisplay()
        
        attributedText.append(NSAttributedString(string: timeAgoDisplay, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14), NSForegroundColorAttributeName: UIColor.gray]))
        return attributedText
    }
    
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

















