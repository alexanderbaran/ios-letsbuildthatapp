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
    private let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UserProfileHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(BaseCell.self, forCellWithReuseIdentifier: cellId)
        
        fetchUser()
        
        setupLogOutButton()
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
            } catch let error {
                print("Failed to sign out:", error)
            }
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .purple
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (view.frame.width / 3) - 1
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
