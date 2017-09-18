//
//  PageCell.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 17/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class PageCell: BaseCell {
    
    var page: Page? {
        didSet {
            guard let page = page else {
                return
            }
            var imageName = page.imageName
            if UIDevice.current.orientation.isLandscape {
                imageName = "\(imageName)_landscape"
            }
            imageView.image = UIImage(named: imageName)
            let color = UIColor(white: 0.2, alpha: 1)
            let titleAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 20, weight: UIFontWeightMedium),
                NSForegroundColorAttributeName: color
            ]
            let messageAttributes = [
                NSFontAttributeName: UIFont.systemFont(ofSize: 14),
                NSForegroundColorAttributeName: color
            ]
            let attributedText = NSMutableAttributedString(string: page.title, attributes: titleAttributes)
            attributedText.append(NSAttributedString(string: "\n\n\(page.message)", attributes: messageAttributes))
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let length = attributedText.string.characters.count
            let range = NSRange(location: 0, length: length)
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: range)
            textView.attributedText = attributedText
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
//        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "page1")
        return iv
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 0, right: 0)
        tv.text = "Sample text for now."
        tv.isEditable = false
        return tv
    }()
    
    let lineSeparatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return view
    }()
    
    override func setupViews() {
//        backgroundColor = .blue
        
        addSubview(imageView)
        addSubview(textView)
        addSubview(lineSeparatorView)
        
        imageView.anchorTo(top: topAnchor, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        
        textView.anchorWithConstantsTo(top: nil, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 16, bottomConstant: 0, rightConstant: -16)
        textView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.3).isActive = true
        
        lineSeparatorView.anchorTo(top: nil, left: leftAnchor, bottom: textView.topAnchor, right: rightAnchor)
        lineSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}

























