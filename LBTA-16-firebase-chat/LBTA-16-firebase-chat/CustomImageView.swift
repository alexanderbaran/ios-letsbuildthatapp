//
//  CustomImageView.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 12/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import  UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView: UIImageView {
    
    /* Some bugs and inconsistencies occur with images when the internet connection is slow when doing async calls with collectionView
     scrolling. We introduce this variable to fix this bug. */
    var imageUrlString: String?
    
    func loadImageUsingUrlString(urlString: String) {
        
        // Blank out the image, before the image can download. So we don't have flicker with the prev image in the cell because of reuse of cells.
        self.image = nil
        
        imageUrlString = urlString
        /* When working with collection views and async data, should always cache the image. Caching the image for scrolling is a good
         practice as it makes everything seem much smoother and does not waste user or server bandwith. */
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
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
                if let downloadedImage = UIImage(data: data!) {
                    if self.imageUrlString == urlString {
                        self.image = downloadedImage
                    }
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                }
            }
        })
        task.resume()
    }
}
