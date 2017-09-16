//
//  ViewController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 12/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    private let userCellId = "userCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        tableView.register(UserCell.self, forCellReuseIdentifier: userCellId)
        
        tableView.allowsMultipleSelectionDuringEditing = true
        
//        observeMessages()
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        print(indexPath.row)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        let message = self.messages[indexPath.row]
        if let chatPartnerId = message.chatPartnerId() {
            Database.database().reference().child("user-messages").child(uid).child(chatPartnerId).removeValue(completionBlock: { (error: Error?, reference: DatabaseReference) in
                if error != nil {
                    print("Failed to delete message: ", error!)
                    return
                }
                /* This is one way of updating the table, but it's actually not that safe. The issue here is that if we delete a message, and send another one to another user, the deleted message comes back. The reason for why that is happening is because the true data storage for all of our messages actually exists inside of messagesDictionary. The approach of deleting the row from the index path is not exactly all that safe because you can have a bunch of messages coming in to your application and what will happen is that through various steps of updating your table you don't actually have a reliable index path to which messages you are trying to delete. Imagine your application having thousands of messages coming in and out, the index path for whenever you hit the delete button is not exactly going to be the correct message when the delete actually occurs. So it actually takes some time perhaps maybe half a second or one whole second, and then the data inside your messages array becomes stale after a while. */
//                self.messages.remove(at: indexPath.row)
//                self.tableView.deleteRows(at: [indexPath], with: .automatic)
                self.messagesDictionary.removeValue(forKey: chatPartnerId)
                // The only disadvantage of this is that the animation is not as smooth.
                self.attemptReloadOfTable()
            })
        }
    }
    
    var messages = [Message]()
    var messagesDictionary = [String: Message]()
    
    private func observeUserMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid failed")
            return
        }
        let ref = Database.database().reference().child("user-messages").child(uid)
        ref.observe(.childAdded) { (snapshot: DataSnapshot) in
//            print(snapshot)
//            let messageId = snapshot.key
            let userId = snapshot.key
            Database.database().reference().child("user-messages").child(uid).child(userId).observe(.childAdded, with: { (snapshot: DataSnapshot) in
//                print(snapshot)
                let messageId = snapshot.key
                self.fetchMessageWithMessageId(messageId: messageId)
            })
        }
        
        // Also listen for when a message is removed in case it gets deleted from an outside source.
        ref.observe(.childRemoved) { (snapshot: DataSnapshot) in
//            print(snapshot.key)
//            print(self.messagesDictionary)
            self.messagesDictionary.removeValue(forKey: snapshot.key)
            // This is actually a func written by us, that does the dispatch inside the function.
            self.attemptReloadOfTable()
        }
    }
    
    private func fetchMessageWithMessageId(messageId: String) {
        let messageReference = Database.database().reference().child("messages").child(messageId)
        messageReference.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let message = Message(dictionary: dictionary)
//                message.setValuesForKeys(dictionary)
                //                print(message.text)
                //                self.messages.append(message)
                if let chatPartnerId = message.chatPartnerId() {
                    self.messagesDictionary[chatPartnerId] = message
                }
                self.attemptReloadOfTable()
            }
        })
    }
    
    var timer: Timer?
    
    private func attemptReloadOfTable() {
        // https://www.youtube.com/watch?v=JK7pHuSfLyA
        /* We invalidate the timer every time we get a new message. And then the last message will run the timer because there
         are no other to invalidate after the last one. */
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 0.15, target: self, selector: #selector(self.handleReloadTable), userInfo: nil, repeats: false)
    }
    
    func handleReloadTable() {
        
        messages = Array(messagesDictionary.values)
        messages.sort(by: { (message1: Message, message2: Message) -> Bool in
            if let m1t = message1.timestamp?.intValue, let m2t = message2.timestamp?.intValue {
                return m1t > m2t
            }
            return false
        })
        
        DispatchQueue.main.async {
            // Should only reload table once and not many times.
            print("we reloaded the table")
            self.tableView.reloadData()
        }
    }
    
//    private func observeMessages() {
//        let ref = Database.database().reference().child("messages")
//        ref.observe(.childAdded, with: { (snapshot: DataSnapshot) in
//            if let dictionary = snapshot.value as? [String: Any] {
//                let message = Message()
//                message.setValuesForKeys(dictionary)
////                print(message.text)
////                self.messages.append(message)
//                if let toId = message.toId {
//                    self.messagesDictionary[toId] = message
//                    self.messages = Array(self.messagesDictionary.values)
//                    self.messages.sort(by: { (message1: Message, message2: Message) -> Bool in
//                        if let m1t = message1.timestamp?.intValue, let m2t = message2.timestamp?.intValue {
//                            return m1t > m2t
//                        }
//                        return false
//                    })
//                }
//                DispatchQueue.main.async {
//                    self.tableView.reloadData()
//                }
//            }
////            print(snapshot)
//        }, withCancel: nil)
//    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Should always dequeue cells, but let's just do it as a hack for now.
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cellId")
        let cell = tableView.dequeueReusableCell(withIdentifier: userCellId, for: indexPath) as! UserCell
        let message = messages[indexPath.row]
        cell.message = message
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let chatPartnerId = message.chatPartnerId() else {
            return
        }
        let ref = Database.database().reference().child("users").child(chatPartnerId)
        ref.observeSingleEvent(of: .value) { (snapshot: DataSnapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = ChatUser()
                user.id = chatPartnerId
                user.setValuesForKeys(dictionary)
//                print(dictionary)
                self.showChatControllerForUser(user: user)
            }
        }
    }
    
    func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navigationController = UINavigationController(rootViewController: newMessageController)
        present(navigationController, animated: true, completion: nil)
    }
    
    func checkIfUserIsLoggedIn() {
        // User is not logged in.
        if Auth.auth().currentUser?.uid == nil {
            // We want to present the controller after its been loaded.
            /* Fixes warnings like:
             Presenting view controllers on detached view controllers is discouraged ..
             Unbalanced calls to begin/end appearance transitions for .. */
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //            handleLogout()
        } else {
            fetchUserAndSetupNavBarTitle()
        }
    }
    
    func fetchUserAndSetupNavBarTitle() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid failed")
            return
        }
        Database.database().reference().child("users").child(uid).observe(.value, with: { (snapshot: DataSnapshot) in
            //                print(snapshot)
            if let dictionary = snapshot.value as? [String: Any] {
//                self.navigationItem.title = dictionary["name"] as? String
                
                let user = ChatUser()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
        }, withCancel: nil)
    }
    
    func setupNavBarWithUser(user: ChatUser) {
//        self.navigationItem.title = user.name
        messages.removeAll()
        messagesDictionary.removeAll()
        tableView.reloadData()
        observeUserMessages()
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = .red
        
        let containerView = UIView()
        containerView.backgroundColor = .yellow
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        let profileImageView = CustomImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
//        profileImageView.layer.masksToBounds = true
        profileImageView.clipsToBounds = true
        if let url = user.profileImageUrl {
            profileImageView.loadImageUsingUrlString(urlString: url)
        }
        
        containerView.addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let nameLabel = UILabel()
        nameLabel.text = user.name
        // nameLabel and other elements needs to be added to a view before constraints below can be applied.
        containerView.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        // Width
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        self.navigationItem.titleView = titleView
        
//        titleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showChatControllerForUser)))
    }
    
    func showChatControllerForUser(user: ChatUser) {
        let layout = UICollectionViewFlowLayout()
        let chatLogController = ChatLogController(collectionViewLayout: layout)
        chatLogController.user = user
//        chatLogController.navigationItem.title = user.name
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func handleLogout() {
        do {
            // Log out user.
            try Auth.auth().signOut()
        } catch let error {
            print(error)
        }
        let loginController = LoginController()
        loginController.messagesController = self
//        navigationController?.pushViewController(loginController, animated: true)
        present(loginController, animated: true, completion: nil)
        // https://stackoverflow.com/questions/37722323/how-to-present-view-controller-from-right-to-left-in-ios-using-swift
//        let transition = CATransition()
//        transition.duration = 0.5
//        transition.type = kCATransitionPush
//        transition.subtype = kCATransitionFromRight
//        view.window!.layer.add(transition, forKey: kCATransition)
//        present(loginController, animated: false, completion: nil)
    }
    
}











