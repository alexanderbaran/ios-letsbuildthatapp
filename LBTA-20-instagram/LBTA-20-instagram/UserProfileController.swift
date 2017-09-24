//
//  UserProfileController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UserProfileHeaderDelegate {
    
    private let headerId = "headerId"
    private let photoCellId = "cellId"
    private let homePostCellId = "homePostCellId"
    
    var user: User?
    
    var posts = [Post]()
    
    var userId: String?
    
    var isGridView = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: photoCellId)
        collectionView?.register(HomePostCell.self, forCellWithReuseIdentifier: homePostCellId)
        
        fetchUser()
        setupLogOutButton()
//        fetchOrderedPosts()
    }
    
    func didChangeToListView() {
        isGridView = false
        collectionView?.reloadData()
    }
    
    func didChangeToGridView() {
        isGridView = true
        collectionView?.reloadData()
    }
    
    private func paginatePosts() {
        guard let uid = user?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
//        let startingValue = "-KukIuJblaisWoCnKqTw"
//        let query = ref.queryOrderedByKey().queryStarting(atValue: startingValue).queryLimited(toFirst: 3)
        let query = ref.queryOrderedByKey()
        if posts.count > 0 {
            
        }
        query.queryLimited(toFirst: 4).observeSingleEvent(of: .value, with: { (snapshot) in
            let allObjects = snapshot.children.allObjects as? [DataSnapshot]
            guard let user = self.user else { return }
            allObjects?.forEach({ (snapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                var post = Post(user: user, dictionary: dictionary)
                post.id = snapshot.key
                self.posts.append(post)
            })
            self.posts.forEach({ (post) in
                print(post.id ?? "")
            })
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to paginate for posts:", error)
        }
    }
    
//    fileprivate func fetchOrderedPosts() {
//        guard let uid = user?.uid else { return }
//        Database.database().reference().child("posts").child(uid).queryOrdered(byChild: "createdDate").observe(.childAdded, with: { (snapshot: DataSnapshot) in
//            guard let dictionary = snapshot.value as? [String: Any] else { return }
//            guard let user = self.user else { return }
//            let post = Post(user: user, dictionary: dictionary)
//            self.posts.insert(post, at: 0)
////            self.posts.append(post)
//            self.collectionView?.reloadData()
//
//        }) { (error: Error) in
//            print("Failed to fetch posts:", error)
//        }
//    }
    
    private func setupLogOutButton() {
        let image = UIImage(named: "gear")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleLogOut))
    }
    
    func handleLogOut() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { (_ UIAlertAction) in
            do {
                try Auth.auth().signOut()
                // Need to present some kind of login controller.
                let loginController = LoginController()
                /* The reason why we need the navigation controller is because we can potentially push the registration controller on to the stack whenever we have the login views in play. */
                let navigationController = UINavigationController(rootViewController: loginController)
                self.present(navigationController, animated: true, completion: nil)
            } catch let error {
                print("Failed to sign out:", error)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Show you how to fire off the paginate call. Check whether or not last cell is being rendered and we'll just fire off the paginate.
        if indexPath.item == self.posts.count - 1 {
            paginatePosts()
        }
        if isGridView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! UserProfilePhotoCell
            cell.post = posts[indexPath.item]
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homePostCellId, for: indexPath) as! HomePostCell
            cell.post = posts[indexPath.item]
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if isGridView {
            let rows: CGFloat = 3
            let size = (view.frame.width - rows + 1 ) / rows
            return CGSize(width: size, height: size)
        } else {
            // userProfileImageView with top and bottom constants above and below the userProfileImageView.
            var height: CGFloat = 40 + 8 + 8
            height += view.frame.width // Square image.
            height += 50 // For bottom row of icons.
            height += 60 // Arbitrary for caption for now.
            return CGSize(width: view.frame.width, height: height)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    fileprivate func fetchUser() {
        let uid = userId ?? (Auth.auth().currentUser?.uid ?? "") // Parentheses not necessary but might be easier to understand.
//        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.fetchUserWithUID(uid: uid, completion: { (user: User) in
            self.user = user
            /* There is also no need to async dispatch the Firebase call. The Firebase client already performs all network and disk related activities on a separate thread. It surfaces the callbacks/blocks on the main thread, so that you can interact with the UI. */
            self.navigationItem.title = self.user?.username
            /* The reason we are doing reload data here is so viewForSupplementaryElementOfKind is re run and user variable is set in header. */
            self.collectionView?.reloadData()
            
//            self.fetchOrderedPosts()
            self.paginatePosts()
        })
    }
    
}

























