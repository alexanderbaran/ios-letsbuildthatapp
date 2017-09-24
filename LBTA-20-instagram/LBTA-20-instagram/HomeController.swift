//
//  HomeController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout, HomePostCellDelegate {
    
    private let homePostCellId = "homePostCellId"

    // An alternative way to the tutorial way of implementing the UIRefreshControl functionality.
    lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: SharePhotoController.updateFeedNotificationName, object: nil)
        
        collectionView?.backgroundColor = .white
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
//        collectionView?.refreshControl = refreshControl
        
        collectionView?.addSubview(refreshControl)
        
        setupNavigationItems()
        
        fetchAllPosts()
    }
    
    func handleUpdateFeed() {
        handleRefresh()
    }
    
    func handleRefresh() {
        /* Stopping the loading like this: self.collectionView?.refreshControl?.endRefreshing(), inside fetchPostWithUser. self.collectionView?.refreshControl is only available in iOS 10 and later. You can check that by clicking on refreshControl and cmd + alt + 0 and check the side bar. If you want to support before iOS 10, you need to call endRefreshing() on the UIRefreshControl itself. */
        // https://stackoverflow.com/questions/22059510/uirefreshcontrol-pull-to-refresh-in-ios-7
        posts.removeAll() // To get a fresh list to append to.
        fetchAllPosts()
    }
    
    private func fetchAllPosts() {
        fetchPosts()
        fetchFollowingUserIds()
    }
    
    private func fetchFollowingUserIds() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("following").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userIdsDictionary = snapshot.value as? [String: Any] else { return }
            userIdsDictionary.forEach({ (key, value) in
                Database.fetchUserWithUID(uid: key, completion: { (user) in
                    self.fetchPostWithUser(user: user)
                })
            })
        }) { (error) in
            print("Failed to get following user ids:", error)
        }
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
            self.posts.sort(by: { $0.creationDate.compare($1.creationDate) == .orderedDescending })
            // No need to dispatch async inside Firebase closures.
            self.collectionView?.reloadData()
//            self.collectionView?.refreshControl?.endRefreshing()
            self.refreshControl.endRefreshing()
        }) { (error: Error) in
            print("Failed to fetch posts:", error)
        }
    }
    
    fileprivate func setupNavigationItems() {
        let logoImage = UIImage(named: "logo2")
        navigationItem.titleView = UIImageView(image: logoImage)
        let cameraImage = UIImage(named: "camera3")?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: cameraImage, style: .plain, target: self, action: #selector(handleCamera))
    }
    
    func handleCamera() {
        let cameraController = CameraController()
        // TODO: Custom animation that animates it from the left to the right.
        present(cameraController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
        cell.post = posts[indexPath.item]
        cell.delegate = self
        return cell
    }
    
    func didTapComment(post: Post) {
        print(post.caption)
        let layout = UICollectionViewFlowLayout()
        let commentsController = CommentsController(collectionViewLayout: layout)
        navigationController?.pushViewController(commentsController, animated: true)
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





















