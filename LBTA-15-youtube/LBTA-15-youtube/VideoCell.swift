//
//  VideoCell.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class VideoCell: BaseCell {
    
    var video: Video? {
        didSet {
            titleLabel.text = video?.title
//            if let thumbnailImageName = video?.thumbnailImageName {
//                thumbnailImageView.image = UIImage(named: thumbnailImageName)
//            }
            setupThumbnailImage()
//            if let profileImageName = video?.channel?.profileImageName {
//                userProfileImageView.image = UIImage(named: profileImageName)
//            }
            setupProfileImage()
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            if let channelName = video?.channel?.name, let numberOfViews = video?.number_of_views {
                subtitleTextView.text = "\(channelName) • \(numberFormatter.string(from: numberOfViews)!) • 2 years ago"
            }
            
            // Measure the title text.
            if let title = video?.title {
                let size = CGSize(width: frame.width - 16 * 2 - 44 - 8, height: 1000)
                let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
                let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
                let estimatedRect = NSString(string: title).boundingRect(with: size, options: options, attributes: attributes, context: nil)
                
                if estimatedRect.height > 20 {
                    titleLabelHeightConstraint?.constant = 44
                } else {
                    titleLabelHeightConstraint?.constant = 20
                }
            }
        }
    }
    
    private func setupThumbnailImage() {
        if let thumbnailImageUrl = video?.thumbnail_image_name {
            thumbnailImageView.loadImageUsingUrlString(urlString: thumbnailImageUrl)
        }
    }
    
    private func setupProfileImage() {
        if let profileImageUrl = video?.channel?.profile_image_name {
            userProfileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
    }
    
    let thumbnailImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
//        imageView.backgroundColor = UIColor.blue
//        imageView.image = UIImage(named: "taylor_swift_blank_space")
        return imageView
    }()
    
    let separatorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        return view
    }()
    
    let userProfileImageView: CustomImageView = {
        let imageView = CustomImageView()
        imageView.contentMode = .scaleAspectFill
//        imageView.backgroundColor = UIColor.green
//        imageView.image = UIImage(named: "taylor_swift_profile")
        imageView.layer.cornerRadius = 22
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.backgroundColor = UIColor.purple
        // Settings this manually because we will not add constraints with format here.
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Taylor Swift - Blank Space"
        label.numberOfLines = 2
        return label
    }()

    let subtitleTextView: UITextView = {
        let textView = UITextView()
//        textView.backgroundColor = UIColor.red
        textView.translatesAutoresizingMaskIntoConstraints = false
        // This text is too long for 1 line on purpose to show what to do so that it will not get cut off at the end/bottom. Just bumping the height from 20 to 30 for now.
        textView.text = "TaylorSwiftVEVO • 1,604,684,607 views • 2 years ago"
        // By default text views have a slight 4 pixel inset from the left.
        textView.textContainerInset = UIEdgeInsets(top: 0, left: -4, bottom: 0, right: 0)
        textView.textColor = UIColor.lightGray
        return textView
    }()
    
    var titleLabelHeightConstraint: NSLayoutConstraint?
    
    override func setupViews() {
//        backgroundColor = UIColor.red
        
        addSubview(thumbnailImageView)
        addSubview(separatorView)
        addSubview(userProfileImageView)
        addSubview(titleLabel)
        addSubview(subtitleTextView)
//        thumbnailImageView.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        addConstraintsWithFormat(format: "H:|-16-[v0]-16-|", views: thumbnailImageView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: separatorView)
        addConstraintsWithFormat(format: "H:|-16-[v0(44)]", views: userProfileImageView)
        
        addConstraintsWithFormat(format: "V:|-16-[v0]-8-[v1(44)]-40-[v2(1)]|", views: thumbnailImageView, userProfileImageView, separatorView)
        
        /* titleLabel is underneath the thumbnailImageView by 8 pixels, and to the right of the userProfileImageView by 8 pixels, and it is
         matching the right of the thumbnailImageView and it has a height of around 20 pixels. The reason we are doing it like this is because
         sometimes we have labels that are taller than just 1 line, and we have to account for how tall it is, so that we can move the
         bottom label a couple of pixels down further, otherwise they will overlap. */
        
        // Top constraint.
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: thumbnailImageView, attribute: .bottom, multiplier: 1, constant: 8))
//        addConstraintsWithFormat(format: "H:[v0(100)]", views: titleLabel)
//        addConstraintsWithFormat(format: "V:[v0(20)]", views: titleLabel)
        // Left constraint.
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right constraint.
        addConstraint(NSLayoutConstraint(item: titleLabel, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height constraint. It is important that we add it like this because we will be modifying it later.
        titleLabelHeightConstraint = NSLayoutConstraint(item: titleLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 44)
        addConstraint(titleLabelHeightConstraint!)
        
        
        // Top constraint.
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 4))
        // Left constraint.
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .left, relatedBy: .equal, toItem: userProfileImageView, attribute: .right, multiplier: 1, constant: 8))
        // Right constraint.
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .right, relatedBy: .equal, toItem: thumbnailImageView, attribute: .right, multiplier: 1, constant: 0))
        // Height constraint. It is important that we add it like this because we will be modifying it later.
        addConstraint(NSLayoutConstraint(item: subtitleTextView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0, constant: 30))
        
        
    }
}














