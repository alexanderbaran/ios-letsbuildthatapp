//
//  ChatLogController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 14/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase

//class ChatLogController: UITableViewController {
//class ChatLogController: UIViewController {
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    var user: ChatUser? {
        didSet {
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    
    var messages = [Message]()
    
    func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("uid failed")
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid)
        userMessagesRef.observe(.childAdded) { (snapshot: DataSnapshot) in
//            print(snapshot)
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message()
                // Potential of crashing if keys don't match.
                message.setValuesForKeys(dictionary)
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                }
            })
        }
    }
    
    private let chatMessageCellId = "chatMessageCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        navigationItem.title = "Chat Log Controller"
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: chatMessageCellId)
        collectionView?.alwaysBounceVertical = true
        setupInputComponents()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatMessageCellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
//        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        return textField
    }()
    
    private func setupInputComponents() {
        let containerView = UIView()
        containerView.backgroundColor = .white
//        containerView.backgroundColor = .red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        /* Even with the constraints below, the containerView is being pinned to the top and not the bottom for some weird reason. We could
         change the type of the class to UIViewController from UITableViewController and that would pin it to the bottom. Or we could change
         it to UICollectionViewController and that would make our lives easier. */
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        // Using type: .system makes the button look more interactive with flashing when you tap. If we create a button like UIButton() then it will be 100% plain.
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        
        containerView.addSubview(sendButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
//        let inputTextField = UITextField()
//        inputTextField.placeholder = "Enter message..."
//        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(inputTextField)
        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(separatorLineView)
        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        
    }
    
    func handleSend() {
//        print(inputTextField.text)
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
        guard let text = inputTextField.text, text != "" else {
            print("empty text")
            return
        }
        guard let toId = user?.id else {
            print("toId failed")
            return
        }
        guard let fromId = Auth.auth().currentUser?.uid else {
            print("fromId failed")
            return
        }
        // https://stackoverflow.com/questions/41574030/timeintervalsince1970-issue-in-swift-3
        // Cast to int if you don't want the decimals, perhaps might be better to include them too in your own app.
        let timestamp = Int(Date().timeIntervalSince1970)
        let values: [String: Any] = ["text": text, "fromId": fromId, "toId": toId, "timestamp": timestamp]
//        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error: Error?, reference: DatabaseReference) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
        }
        
        
        
        
        inputTextField.text = ""
    }
    
    // When we tap enter we execute this code.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}








