//
//  PageCell.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 17/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class PageCell: BaseCell {
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.layer.masksToBounds = true
        iv.clipsToBounds = true
//        iv.backgroundColor = .yellow
        iv.image = UIImage(named: "page1")
        return iv
    }()
    
    override func setupViews() {
//        backgroundColor = .blue
        
        addSubview(imageView)
        imageView.anchorToTop(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor)
    }
    
}
