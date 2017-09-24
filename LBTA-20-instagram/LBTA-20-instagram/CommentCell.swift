//
//  CommentCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 24/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class CommentCell: BaseCell {
    
    var comment: Comment? {
        didSet {
            guard let user = comment?.user else { return }
            guard let comment = comment else { return }
            profileImageView.loadImage(urlString: user.profileImgUrl)
            commentTextView.attributedText = CommentCell.attributedText(username: user.username, text: comment.text)
//            commentLabel.attributedText = CommentCell.attributedText(username: user.username, text: comment.text)
        }
    }
    
    let profileImageView: CachedImageView = {
        let imageView = CachedImageView()
//        imageView.backgroundColor = .gray
        imageView.layer.cornerRadius = 20
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // https://stackoverflow.com/questions/18070484/ios-ui-best-practice-uilabel-or-uitextview
    // Go for UITextView if you want to let the user to be able to copy the text.
    let commentTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.backgroundColor = .clear
//        textView.backgroundColor = .gray
        textView.isEditable = false
        textView.isScrollEnabled = false
        return textView
    }()
    
//    // UILabel centers the text vertically, and it has less padding than UITextView too. Users can't select text which might suck.
//    let commentLabel: UILabel = {
//        let label = UILabel()
//        label.font = UIFont.systemFont(ofSize: 16)
////        label.backgroundColor = .gray
//        label.numberOfLines = 0
//        return label
//    }()
    
    let cellSeparator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    static func attributedText(username: String, text: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString(string: username, attributes: [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: " \(text)", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)]))
        return attributedText
    }

    override func setupViews() {
        super.setupViews()
        
//        backgroundColor = .yellow
        
        addSubview(profileImageView)
        addSubview(commentTextView)
//        addSubview(commentLabel)
        addSubview(cellSeparator)
        
        profileImageView.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 8, leftConstant: 8, bottomConstant: 0, rightConstant: 0, widthConstant: 40, heightConstant: 40)
        
        commentTextView.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 8, bottomConstant: 0, rightConstant: -8, widthConstant: 0, heightConstant: 0)
//        commentLabel.anchor(top: topAnchor, left: profileImageView.rightAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 4, leftConstant: 4, bottomConstant: -4, rightConstant: -4, widthConstant: 0, heightConstant: 0)
        
        // bottomConstant: 1 is a small hack because it is stacking up with the keyboardInputViewSeparator.
        cellSeparator.anchor(top: nil, left: commentTextView.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
//        cellSeparator.anchor(top: nil, left: commentLabel.leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 1, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
    }
    
}








