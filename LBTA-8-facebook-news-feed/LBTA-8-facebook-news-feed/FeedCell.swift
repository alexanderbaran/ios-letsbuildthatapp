//
//  FeedCell.swift
//  LBTA-8-facebook-news-feed
//
//  Created by Alexander Baran on 08/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import Foundation
import UIKit

/* There is one drawback to using a dictionary like this, and that drawback is namely when your app grows in size. Imagine you have hundreds of cells and
 we are storing all the images in the cache like this. The drawback to that the app is gonna grow in terms of size and memory. And Apple OS pretty much kills
 your app if your app is too large. What that means is that you are kinda required to clear out this cache if your memory receives a warning, and that
 warning comes in your controller. Inside of didReceiveMemoryWarning(). There is an easier way to implementing a flush or a way to make sure the cache
 doesn't grow too large, is to use a built i cache object called NSCache. There is an even easier way, that lets us not have to even manage a cache.
 Some images are being are alot smaller in size so they are able to be cached internally by the default URLSession cache. It caches http calls. */
//var imageCache = [String: UIImage]()
//var imageCache = NSCache<AnyObject, AnyObject>()

class FeedCell: UICollectionViewCell {
    
    var feedController: FeedController?
    
    /* We want to animate on to the entire view controllers view, and not just the subcell and the collection view. */
    func animate() {
        feedController?.animateImageView(statusImageView: statusImageView)
    }
    
    /* You should keep your logic where it belongs. Settings up the cell actually belongs inside of the cell. Your controller does not need to do too much work. */
    var post: Post? {
        didSet {
            
            statusImageView.image = nil
            
            //            if let statusImageName = post?.statusImageName {
            //                statusImageView.image = UIImage(named: statusImageName)
            //                loader.stopAnimating()
            //            }
            
            if let statusImageUrl = post?.statusImageUrl {
                
                // Check for cache first.
//                if let image = imageCache[statusImageUrl] {
//                if let image = imageCache.object(forKey: statusImageUrl as AnyObject) {
//                    statusImageView.image = image as? UIImage
//                    loader.stopAnimating()
//                } else {
                    let url = URL(string: statusImageUrl)!
                    let task = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        let image = UIImage(data: data!)
                        
//                        imageCache[statusImageUrl] = image
//                        imageCache.setObject(image!, forKey: statusImageUrl as AnyObject)
                        
                        DispatchQueue.main.async {
                            self.statusImageView.image = image
                            self.loader.stopAnimating()
                        }
                    })
                    task.resume()
//                }
            }
            
            setupNameLocationAtatusAndProfileImage()
        }
    }
    
    private func setupNameLocationAtatusAndProfileImage() {
        if let name = post?.name {
            // With NSMutableAttributedString you can add and append attributes compared to NSAttributedString.
            let attributedText = NSMutableAttributedString(string: name, attributes: [
                NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)
                ])
            attributedText.append(NSAttributedString(string: "\nDecember 18 • San Francisco • ", attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 12),
                NSForegroundColorAttributeName: UIColor.rgb(red: 155, green: 161, blue: 171)
                ]))
            
            // To increase the spacing between the lines.
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 4
            attributedText.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, attributedText.string.characters.count))
            
            let attachment = NSTextAttachment()
            attachment.image = UIImage(named: "globe_small")
            attachment.bounds = CGRect(x: 0, y: -2, width: 12, height: 12)
            attributedText.append(NSAttributedString(attachment: attachment))
            
            nameLabel.attributedText = attributedText
        }
        
        if let statusText = post?.statusText {
            statusTextView.text = statusText
        }
        
        if let profileImageName = post?.profileImageName {
            profileImageview.image = UIImage(named: profileImageName)
        }
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2
        return label
    }()
    
    let profileImageview: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckprofile")
        imageView.contentMode = .scaleAspectFit
        //        imageView.backgroundColor = UIColor.red
        return imageView
    }()
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.text = "Meanwhile, Beast turned to the dark side."
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.isScrollEnabled = false
        return textView
    }()
    
    let statusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "zuckdog")
        imageView.contentMode = .scaleAspectFill
        // https://stackoverflow.com/questions/39466001/maskstobounds-vs-clipstobounds
        /* IMHO answers here don't explain explain the difference.. I guess the difference is that one is for layers, one for views ;) ultimately the same ... the linked question's answer is good */
        imageView.layer.masksToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let likesCommentsLabel: UILabel = {
        let label = UILabel()
        label.text = "488 Likes   10.7K Comments"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.rgb(red: 155, green: 161, blue: 171)
        return label
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(red: 226, green: 228, blue: 232)
        return view
    }()
    
    let likeButton = FeedCell.buttonForTitle(title: "Like", imageName: "like")
    let commentButton = FeedCell.buttonForTitle(title: "Comment", imageName: "comment")
    let shareButton = FeedCell.buttonForTitle(title: "Share", imageName: "share")
    
    static func buttonForTitle(title: String, imageName: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(UIColor.rgb(red: 143, green: 150, blue: 162), for: .normal)
        button.setImage(UIImage(named: imageName), for: .normal)
        // Image and text is a little cramped so we fix it like this. Top, left, bottom, right.
        // This will give us left of the center, the label is going to be placed 8 pixels to the right.
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 8, 0, 0)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(nameLabel)
        addSubview(profileImageview)
        addSubview(statusTextView)
        addSubview(statusImageView)
        addSubview(likesCommentsLabel)
        addSubview(dividerLineView)
        
        addSubview(likeButton)
        addSubview(commentButton)
        addSubview(shareButton)
        
        statusImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(animate)))
        
        setupStatusImageViewLoader()
        
        addConstraintsWithFormat(format: "H:|-8-[v0(44)]-8-[v1]|", views: profileImageview, nameLabel)
        addConstraintsWithFormat(format: "H:|-4-[v0]-4-|", views: statusTextView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: statusImageView)
        addConstraintsWithFormat(format: "H:|-12-[v0]|", views: likesCommentsLabel)
        addConstraintsWithFormat(format: "H:|-12-[v0]-12-|", views: dividerLineView)
        
        // Button constraints. If we specify the horizontal size of v0 to be v1, they will share the same space equally.
        //        addConstraintsWithFormat(format: "H:|[v0(v1)][v1]|", views: likeButton, commentButton)
        // We say that v0 and v1 has the same width as v2. Share the space equally based on what v2 will be.
        addConstraintsWithFormat(format: "H:|[v0(v2)][v1(v2)][v2]|", views: likeButton, commentButton, shareButton)
        
        addConstraintsWithFormat(format: "V:|-12-[v0]", views: nameLabel)
        // The button itself comes with a top and bottom padding, so we will remove the 8 pixels above and below the button.
        /* The view that does not have a specific height, will expand the entire width or the entire height of the cell. In this case statusImageView. If we change
         v2 height to 200, and take away v1 height, then the statusTextView will take the remainder of the height. But still scrolling and not showing the whole
         text. */
        addConstraintsWithFormat(format: "V:|-8-[v0(44)]-4-[v1]-4-[v2(200)]-8-[v3(24)]-8-[v4(0.5)][v5(44)]|", views: profileImageview, statusTextView, statusImageView, likesCommentsLabel, dividerLineView, likeButton)
        
        // We know the button belongs to the very bottom. So we can just do this.
        /* The non hack way of adding the buttons is to include a single container view that includes those 3 buttons, and specify that as v5 above instead of likeButton. */
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: commentButton)
        addConstraintsWithFormat(format: "V:[v0(44)]|", views: shareButton)
        
    }
    
    let loader = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    func setupStatusImageViewLoader() {
        loader.hidesWhenStopped = true
        loader.startAnimating()
        loader.color = UIColor.black
        statusImageView.addSubview(loader)
        statusImageView.addConstraintsWithFormat(format: "H:|[v0]|", views: loader)
        statusImageView.addConstraintsWithFormat(format: "V:|[v0]|", views: loader)
    }
}









