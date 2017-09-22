//
//  UserProfilePhotoCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: BaseCell {
    
    var post: Post? {
        didSet {
            guard let imageUrl = post?.imageUrl else { return }
            /* If we had made a request here to load the image, we would need to have done something like below inside the callback after the error check, to prevent images being incorrectly shown in the cells because of the async nature of the callback and the unpredictable order. Where url is the url in the URLSession.shared.dataTask method. Usually the sympton is repeating same photos in some of the cells. Check instagram video tutorial 18 for video. */
//            if url.absoluteString != self.post?.imageUrl {
//                return
//            }
            photoImageView.loadImage(urlString: imageUrl)
        }
    }
    
    let photoImageView: CachedImageView = {
        let imageView = CachedImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override func setupViews() {
        super.setupViews()
        
        addSubview(photoImageView)
        photoImageView.fillSuperview()
    }
    
}
