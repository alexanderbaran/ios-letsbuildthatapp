//
//  CommentInputTextView.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 19/03/2018.
//  Copyright © 2018 Alexander Baran. All rights reserved.
//

import UIKit

class CommentInputTextView: UITextView {
    
    private let placeholderLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter Comment"
        label.textColor = UIColor.lightGray
        return label
    }()
    
    func showPlaceholderLabel() {
        placeholderLabel.isHidden = false
    }
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CommentInputTextView deinit")
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupViews() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextChange), name: .UITextViewTextDidChange, object: nil)
        
        addSubview(placeholderLabel)
        placeholderLabel.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 8, leftConstant: 4, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0)
    }
    
    @objc func handleTextChange() {
        placeholderLabel.isHidden = !self.text.isEmpty
        print(self.text)
    }
}
