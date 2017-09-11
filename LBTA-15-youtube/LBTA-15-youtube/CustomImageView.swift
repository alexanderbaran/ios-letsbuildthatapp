//
//  CustomImageView.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import  UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    /* Some bugs and inconsistencies occur with images when the internet connection is slow when doing async calls with collectionView
     scrolling. We introduce this variable to fix this bug. */
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        imageUrlString = urlString
        /* When working with collection views and async data, should always cache the image. Caching the image for scrolling is a good
         practice as it makes everything seem much smoother and does not waste user or server bandwith. */
        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = imageFromCache
            return
        }
        //        print("requesting...")
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                let imageToCache = UIImage(data: data!)
                // To prevent async image load scrolling bug on slow internet connections.
                if self.imageUrlString == urlString {
                    self.image = imageToCache
                }
                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
            }
        })
        task.resume()
    }
}
