
//
//  NewMessageController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 13/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class NewMessageController: UITableViewController {

    let userCellId = "userCellId"
    
    var users = [ChatUser]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        
        tableView.register(UserCell.self, forCellReuseIdentifier: userCellId)
        
        fetchUser()
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot: DataSnapshot) in
//            print(snapshot)
            if let dictionary = snapshot.value as? [String: Any] {
                let user = ChatUser()
                /* If you use this setter, your app will crash if your class properties dont exactly match up with the dictionary keys. */
                user.setValuesForKeys(dictionary)
//                user.name = dictionary["name"]
//                user.email = dictionary["email"]
//                print(user.name!, user.email!)
                self.users.append(user)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }, withCancel: nil)
    }
    
    func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as! UserCell
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: userCellId)
//        let user = users[indexPath.row]
//        cell.textLabel?.text = user.name
//        cell.detailTextLabel?.text = user.email
        return cell
    }
}
