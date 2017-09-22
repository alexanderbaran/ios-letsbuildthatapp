//
//  UserProfileController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class UserProfileController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let headerId = "headerId"
    private let photoCellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(UserProfilePhotoCell.self, forCellWithReuseIdentifier: photoCellId)
        
        fetchUser()
        
        setupLogOutButton()
        
//        fetchPosts()
        fetchOrderedPosts()
    }
    
    var posts = [Post]()
    
//    fileprivate func fetchPosts() {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let ref = Database.database().reference().child("posts").child(uid)
////        posts = [Post]()
//        ref.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
//            guard let dictionaries = snapshot.value as? [String: Any] else { return }
//            dictionaries.forEach({ (key: String, value: Any) in
////                print("key \(key)", "value \(value)")
//                guard let dictionary = value as? [String: Any] else { return }
//                let post = Post(dictionary: dictionary)
//                self.posts.append(post)
//            })
//            // No need to dispatch async inside Firebase closures.
//            self.collectionView?.reloadData()
//        }) { (error: Error) in
//            print("Failed to fetch posts:", error)
//        }
//    }
    
    fileprivate func fetchOrderedPosts() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = Database.database().reference().child("posts").child(uid)
        ref.queryOrdered(byChild: "createdDate").observe(.childAdded, with: { (snapshot: DataSnapshot) in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            let post = Post(dictionary: dictionary)
            self.posts.append(post)
            self.collectionView?.reloadData()

        }) { (error: Error) in
            print("Failed to fetch posts:", error)
        }
    }
    
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellId, for: indexPath) as! UserProfilePhotoCell
        cell.post = posts[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rows: CGFloat = 3
        let size = (view.frame.width - rows + 1 ) / rows
        return CGSize(width: size, height: size)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! UserProfileHeader
        header.user = user
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
    var user: User?
    
    fileprivate func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
//            print(snapshot.value ?? "")
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            self.user = User(dictionary: dictionary)
            /* There is also no need to async dispatch the Firebase call. The Firebase client already performs all network and disk related activities on a separate thread. It surfaces the callbacks/blocks on the main thread, so that you can interact with the UI. */
            self.navigationItem.title = self.user?.username
            /* The reason we are doing reload data here is so viewForSupplementaryElementOfKind is re run and user variable is set in header. */
            self.collectionView?.reloadData()
        }) { (error: Error) in
            print("Failed to fetch user:", error)
        }
    }
    
}
