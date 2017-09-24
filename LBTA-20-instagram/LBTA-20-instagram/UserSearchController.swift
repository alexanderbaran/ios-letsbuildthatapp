//
//  UserSearchController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 22/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class UserSearchController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    private let userSearchCellId = "userSearchCellId"
    
    // https://developer.apple.com/documentation/uikit/uisearchbar
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Enter username"
//        sb.barTintColor = .gray
        let searchTextField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchTextField.backgroundColor = UIColor.rgb(red: 230, green: 230, blue: 230)
        sb.delegate = self
        return sb
    }()
    
    var filteredUsers = [User]()
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        if searchText == "" {
        if searchText.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { (user: User) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
        }
        self.collectionView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.alwaysBounceVertical = true
        collectionView?.keyboardDismissMode = .onDrag
        
        collectionView?.register(UserSearchCell.self, forCellWithReuseIdentifier: userSearchCellId)

//        navigationItem.titleView = searchBar
        
        // This looks different on my own device that runs iOS 10.3. It looks like the search bar on tutorial.
        navigationController?.navigationBar.addSubview(searchBar)
        guard let navBar = navigationController?.navigationBar else { return }
        searchBar.anchor(top: navBar.topAnchor, left: navBar.leftAnchor, bottom: navBar.bottomAnchor, right: navBar.rightAnchor, topConstant: 0, leftConstant: 8, bottomConstant: 0, rightConstant: -8, widthConstant: 0, heightConstant: 0)
        
        fetchUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        searchBar.isHidden = false
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        searchBar.isHidden = true
        // Hides keyboard.
        searchBar.resignFirstResponder()
        let user = filteredUsers[indexPath.item]
        let layout = UICollectionViewFlowLayout()
        let userProfileController = UserProfileController(collectionViewLayout: layout)
        userProfileController.user = user
        userProfileController.userId = user.uid
        navigationController?.pushViewController(userProfileController, animated: true)
    }
    
    var users = [User]()
    
    private func fetchUsers() {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { (snapshot) in
            guard let dictionaries = snapshot.value as? [String: Any] else { return }
            dictionaries.forEach({ (key, value) in
                if key == Auth.auth().currentUser?.uid {
                    print("Found myself, omit from list")
                    // return works here because we are inside a closure.
                    return
                }
//                print("key: \(key), value: \(value)")
                guard let userDictionary = value as? [String: Any] else { return }
                let user = User(uid: key, dictionary: userDictionary)
                self.users.append(user)
            })
//            self.users.sort(by: { (user1, user2) -> Bool in
////                return user1.username < user2.username
//                return user1.username.compare(user2.username) == .orderedAscending
//            })
            self.users.sort(by: { $0.username.compare($1.username) == .orderedAscending })
            self.filteredUsers = self.users
            self.collectionView?.reloadData()
        }) { (error) in
            print("Failed to fetch users for search:", error)
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: userSearchCellId, for: indexPath) as! UserSearchCell
        cell.user = filteredUsers[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 66 = 50 + 8 + 8. Based on image height and top and bottom margins.
        return CGSize(width: view.frame.width, height: 66)
    }
    
}




















