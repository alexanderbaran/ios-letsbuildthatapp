//
//  AppCell.swift
//  LBTA-13-app-store
//
//  Created by Alexander Baran on 09/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class AppCell: UICollectionViewCell {
    
    var app: App? {
        didSet {
            if let name = app?.name {
                nameLabel.text = name
                
                let rect = NSString(string: name).boundingRect(with: CGSize(width: frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
                
                if rect.height > 20 {
                    // Two lines.
                    nameLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 5, width: frame.width, height: 40)
                } else {
                    // One line.
                    nameLabel.frame = CGRect(x: 0, y: imageView.frame.maxY + 5, width: frame.width, height: 20)
                }
                // sizeToFit makes it no longer in the center of the frame. Becomes a little tighter.
                nameLabel.sizeToFit()
                categoryLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY, width: frame.width, height: 18)
                priceLabel.frame = CGRect(x: 0, y: categoryLabel.frame.maxY, width: frame.width, height: 18)
 
            }
            categoryLabel.text = app?.category
            if let price = app?.price {
                priceLabel.text = "$\(price)"
            } else {
                // Some apps are free.
                priceLabel.text = ""
            }
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "frozen")
        iv.contentMode = .scaleAspectFill
        // https://developer.apple.com/documentation/quartzcore/calayer
        iv.layer.cornerRadius = 16
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Disney Build It: Frozen"
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 2
        return label
    }()
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "Entertainment"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    let priceLabel: UILabel = {
        let label = UILabel()
        label.text = "$3.99"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.darkGray
        return label
    }()
    
    func setupViews() {
//        backgroundColor = UIColor.black
        addSubview(imageView)
        addSubview(nameLabel)
        addSubview(categoryLabel)
        addSubview(priceLabel)
        
        // Not going to use constraints here but rects. Easier for this situation.
        // frame.width and frame.height are the dimensions of the AppCell. Both width and height are frame.width here because we want a square image.
        imageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.width)
        // UILabel has it's own top and bottom padding so don't worry even if it looks like the distance is more than 2.
        nameLabel.frame = CGRect(x: 0, y: imageView.frame.maxY, width: frame.width, height: 40)
        categoryLabel.frame = CGRect(x: 0, y: nameLabel.frame.maxY, width: frame.width, height: 18)
        priceLabel.frame = CGRect(x: 0, y: categoryLabel.frame.maxY, width: frame.width, height: 18)
    }
}







