//
//  ViewController.swift
//  LBTA-8-facebook-news-feed
//
//  Created by Alexander Baran on 07/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

let cellId = "cellId"
let posts = Posts()

class FeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let samplePost = Post()
//        samplePost.perform(Selector("setName:"), with: "myname")
//        print(samplePost.name)
        
        if let path = Bundle.main.path(forResource: "all_posts", ofType: "json") {
            let url = URL(fileURLWithPath: path)
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                // Make sure you are using the correct method next time. Took 30 mins to figure out.
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                
//                if let postDictionary = json?["posts"] as? [String: Any] {
////                    print(postDictionary)
//                    let post = Post()
//                    // Must inherit from NSObject to be able to do this. Ints must be NSNumber in order for this to work.
//                    post.setValuesForKeys(postDictionary)
//                    posts.postsList = [post]
//                }
                
                if let postsArray = json?["posts"] as? [[String: Any]] {
                    for postDictionary in postsArray {
                        let post = Post()
                        post.setValuesForKeys(postDictionary)
                        posts.postsList.append(post)
                    }
                }
                

            } catch let error {
                print(error)
            }
        
        }
        
        // 500 MB.
        let memoryCapacity = 500 * 1024 * 1024
        let diskCapacity = 500 * 1024 * 1024
        // Doesn't really matter what you enter in for diskPath.
        let urlCache = URLCache(memoryCapacity: memoryCapacity, diskCapacity: diskCapacity, diskPath: "myDiskPath")
        URLCache.shared = urlCache
        
        navigationItem.title = "Facebook Feed"
        
        collectionView?.alwaysBounceVertical = true
        
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    
    // Flushing the dictionary cache.
//    override func didReceiveMemoryWarning() {
//        imageCache = [String: UIImage]()
//    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.numberOfPosts()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let feedCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! FeedCell
        feedCell.feedController = self
        feedCell.post = posts[indexPath.item]
        return feedCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* The sizing of these cells do get very tricky when you have variable text height, you have to account for the height of the text blocks, and also
         you have to account for the height of the image view, it is always varying. The sizes change alot. */
        if let statusText = posts[indexPath.item].statusText {
            // NSString has a method on it called boundingRectWithSize, and this will estimate our text size for us.
            let rect = NSString(string: statusText).boundingRect(with: CGSize(width: view.frame.width, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)], context: nil)
            let knownHeight: CGFloat = 8 + 44 + 4 + 4 + 200 + 8 + 24 + 8 + 44
            // The last 24 is because it needed some extra space to show properly. Still missing the bottom of the Trump sentence.
            return CGSize(width: view.frame.width, height: rect.height + knownHeight + 24)
        }
        return CGSize(width: view.frame.width, height: 500)
    }
    
    // Need this method if we want landscape mode to work propery.
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        // When you change the size of the device, just invalidate the layout and redraw yourself completely.
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    let blackBackgroundView = UIView()
    let zoomImageView = UIImageView()
    let navBarCoverView = UIView()
    let tabBarCoverView = UIView()
    
    var statusImageView: UIImageView?
    
    func animateImageView(statusImageView: UIImageView) {
        
        self.statusImageView = statusImageView
        
        // This is how we get the absolute coordinates for our frame.
        if let startingFrame = statusImageView.superview?.convert(statusImageView.frame, to: nil) {
            
            // Turning off the alpha of the original image.
            statusImageView.alpha = 0
            
            blackBackgroundView.backgroundColor = UIColor.black
            blackBackgroundView.frame = view.frame
            // Set alpha to 0 so we can animate it.
            blackBackgroundView.alpha = 0
            view.addSubview(blackBackgroundView)
            
            // Statusbar is 20 pixels tall, 44 for the nav bar.
            navBarCoverView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 20 + 44)
            navBarCoverView.backgroundColor = UIColor.black
            navBarCoverView.alpha = 0
            
            // This gets us the actual applications window.
            if let keyWindow = UIApplication.shared.keyWindow {
                keyWindow.addSubview(navBarCoverView)
                
                tabBarCoverView.frame = CGRect(x: 0, y: keyWindow.frame.height - 49, width: view.frame.width, height: 49)
                tabBarCoverView.backgroundColor = UIColor.black
                tabBarCoverView.alpha = 0
                
                keyWindow.addSubview(tabBarCoverView)
            }
            
            // We can't add it to this view, because we need to get above it. Nav bar is above the main view.
//            view.addSubview(navBarCoverView)
            
            zoomImageView.backgroundColor = UIColor.red
            zoomImageView.frame = startingFrame
            zoomImageView.isUserInteractionEnabled = true
            zoomImageView.image = statusImageView.image
            zoomImageView.contentMode = .scaleAspectFill
            zoomImageView.clipsToBounds = true
            view.addSubview(zoomImageView)
            
            zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(zoomOut)))
            
            UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: { 
                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
                let y = (self.view.frame.height / 2) - (height / 2)
                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
                self.blackBackgroundView.alpha = 1
                self.navBarCoverView.alpha = 1
                self.tabBarCoverView.alpha = 1
            }, completion: nil)
            
//            UIView.animate(withDuration: 0.75) {
//                let height = (self.view.frame.width / startingFrame.width) * startingFrame.height
//                let y = (self.view.frame.height / 2) - (height / 2)
//                self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
//                self.blackBackgroundView.alpha = 1
//                self.navBarCoverView.alpha = 1
//                self.tabBarCoverView.alpha = 1
//            }
        }
    }
    
    func zoomOut() {
        if let startingFrame = statusImageView!.superview?.convert(statusImageView!.frame, to: nil) {
            UIView.animate(withDuration: 0.75, animations: { 
                self.zoomImageView.frame = startingFrame
                self.blackBackgroundView.alpha = 0
                self.tabBarCoverView.alpha = 0
                self.navBarCoverView.alpha = 0
            }, completion: { (didComplete: Bool) in
                self.zoomImageView.removeFromSuperview()
                self.blackBackgroundView.removeFromSuperview()
                self.navBarCoverView.removeFromSuperview()
                self.tabBarCoverView.removeFromSuperview()
                self.statusImageView?.alpha = 1
            })
        }
    }
}






