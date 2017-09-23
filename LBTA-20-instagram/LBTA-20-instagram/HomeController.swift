//
//  HomeController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let homePostCellId = "homePostCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        setupNavigationItems()
        fetchPosts()
    }
    
    var posts = [Post]()
    
    fileprivate func fetchPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid, completion: { (user: User) in
//            print("Done fetching, now doing some afterwork.")
            self.fetchPostWithUser(user: user)
        })
    }
    
    private func fetchPostWithUser(user: User) {
        Database.database().reference().child("posts").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key: String, value: Any) in
                //                print("key \(key)", "value \(value)")
                guard let dictionary = value as? [String: Any] else { return }
                let post = Post(user: user, dictionary: dictionary)
                self.posts.append(post)
            })
            // No need to dispatch async inside Firebase closures.
            self.collectionView?.reloadData()
        }) { (error: Error) in
            print("Failed to fetch posts:", error)
        }
    }
    
    fileprivate func setupNavigationItems() {
        navigationItem.titleView = UIImageView(image: UIImage(named: "logo2"))
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // userProfileImageView with top and bottom constants above and below the userProfileImageView.
        var height: CGFloat = 40 + 8 + 8
        height += view.frame.width // Square image.
        height += 50 // For bottom row of icons.
        height += 60 // Arbitrary for caption for now.
        return CGSize(width: view.frame.width, height: height)
    }
    
}





















