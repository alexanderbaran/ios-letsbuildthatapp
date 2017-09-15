//
//  ChatMessageCell.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 15/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ChatMessageCell: BaseCell {
    
//    var message: Message? {
//        didSet {
//            
//        }
//    }
    
    // UICollectionViewCell does not have default text labels compared to UITableViewCell so we need to make them.
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "SAMPLE TEXT FOR NOW"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    override func setupViews() {
//        backgroundColor = .red
        addSubview(textView)
        textView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.widthAnchor.constraint(equalToConstant: 200).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
    }
}
