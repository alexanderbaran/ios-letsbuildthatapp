//
//  Extensions.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}

//extension UIImageView {
//    func loadImageUsingUrlString(urlString: String) {
//        /* When working with collection views and async data, should always cache the image, or else some bugs occur when the internet connection
//         is slow. Caching the image for scrolling is a good practice anyways as it makes everything seem much smoother and does not waste user
//         or server bandwith and prevents inconsistencies and bugs when scrolling. */
//        if let imageFromCache = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
//            self.image = imageFromCache
//            return
//        }
////        print("requesting...")
//        let url = URL(string: urlString)!
//        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            DispatchQueue.main.async {
//                let imageToCache = UIImage(data: data!)
//                imageCache.setObject(imageToCache!, forKey: urlString as AnyObject)
//                self.image = imageToCache
//            }
//        })
//        task.resume()
//    }
//}
