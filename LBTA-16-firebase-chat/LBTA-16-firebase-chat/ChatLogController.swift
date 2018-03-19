//
//  ChatLogController.swift
//  LBTA-16-firebase-chat
//
//  Created by Alexander Baran on 14/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Firebase
import MobileCoreServices
import AVFoundation

//class ChatLogController: UITableViewController {
//class ChatLogController: UIViewController {
class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
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
        guard let toId = user?.id else {
            print("userId failed")
            return
        }
        let userMessagesRef = Database.database().reference().child("user-messages").child(uid).child(toId)
        userMessagesRef.observe(.childAdded) { (snapshot: DataSnapshot) in
//            print(snapshot)
            let messageId = snapshot.key
            let messagesRef = Database.database().reference().child("messages").child(messageId)
            messagesRef.observeSingleEvent(of: .value, with: { (snapshot: DataSnapshot) in
                guard let dictionary = snapshot.value as? [String: Any] else {
                    return
                }
                let message = Message(dictionary: dictionary)
                // Potential of crashing if keys don't match.
//                message.setValuesForKeys(dictionary)
//                print("We fetched a message from Firebase, and we need to decide whether or not to filter it out:", message.text!)
                // Do we need to attempt filtering anymore?
//                if message.chatPartnerId() == self.user?.id {
//                    self.messages.append(message)
//                    DispatchQueue.main.async {
//                        self.collectionView?.reloadData()
//                    }
//                }
                self.messages.append(message)
                DispatchQueue.main.async {
                    self.collectionView?.reloadData()
                    
                    let indexPath = IndexPath(item: self.messages.count - 1, section: 0)
                    self.collectionView?.scrollToItem(at: indexPath, at: .bottom, animated: false)
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
//        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        // This prevents flickering of placeholder text and button on inputAccessoryView on simulator for some weird reason, but we also needs to scroll to bottom after loading messages because it does not do so automatically when setting top edge inset.
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
//        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.keyboardDismissMode = .interactive
//        setupInputComponents()
        setupKeyboardObservers()
    }
    
    lazy var inputContainerView: ChatInputContainerView = {
        
        let frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        let chatInputContainerView = ChatInputContainerView(frame: frame)
        chatInputContainerView.chatLogController = self
        return chatInputContainerView
        
//        let containerView = UIView()
//        containerView.backgroundColor = .white
//        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        //        containerView.backgroundColor = .red
//        containerView.translatesAutoresizingMaskIntoConstraints = false
        
//        self.view.addSubview(containerView)
        /* Even with the constraints below, the containerView is being pinned to the top and not the bottom for some weird reason. We could
         change the type of the class to UIViewController from UITableViewController and that would pin it to the bottom. Or we could change
         it to UICollectionViewController and that would make our lives easier. */
//        containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        containerView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
//        let uploadImageView = UIImageView()
//        uploadImageView.image = UIImage(named: "upload_image_icon")
//        uploadImageView.translatesAutoresizingMaskIntoConstraints = false
//        uploadImageView.isUserInteractionEnabled = true
//        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleUploadTap)))
//        
//        containerView.addSubview(uploadImageView)
//        uploadImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        uploadImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        // Apple recommends that buttons are of size 44, it fits for you finger.
//        uploadImageView.widthAnchor.constraint(equalToConstant: 44).isActive = true
//        uploadImageView.heightAnchor.constraint(equalToConstant: 44).isActive = true
//        
//        
//        // Using type: .system makes the button look more interactive with flashing when you tap. If we create a button like UIButton() then it will be 100% plain.
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        
//        containerView.addSubview(sendButton)
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
//        containerView.addSubview(self.inputTextField)
//        self.inputTextField.leftAnchor.constraint(equalTo: uploadImageView.rightAnchor, constant: 8).isActive = true
//        self.inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        self.inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        self.inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
//        let separatorLineView = UIView()
//        separatorLineView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(separatorLineView)
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        //        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//        return containerView
    }()
    
    func handleUploadTap() {
//        print("we tapped upload")
        let imagePickerController = UIImagePickerController()
        imagePickerController.mediaTypes = [kUTTypeImage as String, kUTTypeMovie as String]
//        imagePickerController.allowsEditing = true
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//        print("we selected an image")
        if let videoUrl = info[UIImagePickerControllerMediaURL] as? URL {
            handleVideoSelectedForUrl(url: videoUrl)
//            print(videoUrl)
        } else {
            handleImageSelectedForInfo(info: info)
        }

        dismiss(animated: true, completion: nil)
    }
    
    private func handleVideoSelectedForUrl(url: URL) {
        let filename = UUID().uuidString + ".mov"
        let uploadTask = Storage.storage().reference().child("message_movies").child(filename).putFile(from: url, metadata: nil, completion: { (metadata: StorageMetadata?, error: Error?) in
            if error != nil {
                print(error!)
                return
            }
            //                print(metadata!)
            if let videoUrl = metadata?.downloadURL()?.absoluteString {
//                print(storageUrl)
                if let thumbnailImage = self.thumbnailImageForFileUrl(fileUrl: url) {
                    
                    self.uploadToFirebaseStorageUsingImage(image: thumbnailImage, completion: { (imageUrl: String) in
                        let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": thumbnailImage.size.width, "imageHeight": thumbnailImage.size.height, "videoUrl": videoUrl]
                        self.sendMessageWithProperties(properties: properties)
                    })

                }
            }
        })
        
        uploadTask.observe(.progress) { (snapshot: StorageTaskSnapshot) in
            if let completedUnitCount = snapshot.progress?.completedUnitCount {
//                print(completedUnitCount)
                self.navigationItem.title = String(completedUnitCount)
            }
        }
        
        uploadTask.observe(.success) { (snapshot: StorageTaskSnapshot) in
            self.navigationItem.title = self.user?.name
        }
    }
    
    private func thumbnailImageForFileUrl(fileUrl: URL) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        // https://stackoverflow.com/questions/5347800/avassetimagegenerator-provides-images-rotated
        imageGenerator.appliesPreferredTrackTransform = true
        // Getting the first frame of the video.
        do {
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(1, 60), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
        } catch let error {
            print(error)
        }
        return nil
    }
    
    private func handleImageSelectedForInfo(info: [String: Any]) {
        var selectedImageFromPicker: UIImage?
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage, completion: { (imageUrl: String) in
                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: selectedImage)
            })
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage, completion: @escaping (_ imageUrl: String) -> ()) {
//        print("Upload to Firebase!")
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference().child("message_images").child("\(imageName).jpg")
        // 0.1 is 10% of the quality.
        guard let uploadData = UIImageJPEGRepresentation(image, 0.2) else {
            return
        }
        ref.putData(uploadData, metadata: nil) { (metadata: StorageMetadata?, error: Error?) in
            if error != nil {
                print("Failed to upload image:", error!)
                return
            }
            if let imageUrl = metadata?.downloadURL()?.absoluteString {
                completion(imageUrl)
//                self.sendMessageWithImageUrl(imageUrl: imageUrl, image: image)
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    override var inputAccessoryView: UIView? {
        // get keyword and brackets are optional if there is no set keyword with brackets.
        get {
//            let containerView = UIView()
//            containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//            containerView.backgroundColor = .lightGray
//            
//            /* Textfield will not work when not referenced outside of this block. */
//            // https://www.youtube.com/watch?v=ky7YRh01by8
//            // 18:00
//            let textField = UITextField()
//            textField.placeholder = "Enter some text"
//            containerView.addSubview(textField)
//            textField.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//            
//            return containerView
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        // https://stackoverflow.com/questions/39757463/is-this-overriding-the-method-or-not
        return true
    }
    
    private func setupKeyboardObservers() {
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardDidShow), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
    }
    
//    func handleKeyboardDidShow() {
//        if messages.count <= 0 {
//            return
//        }
//        let indexPath = IndexPath(item: messages.count - 1, section: 0)
//        // Not sure why at is .top and not .bottom.
//        collectionView?.scrollToItem(at: indexPath, at: .top, animated: true)
//    }
//
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        // Remove observers to prevent memory leak.
//        NotificationCenter.default.removeObserver(self)
//    }
    
//    func handleKeyboardWillShow(notification: Notification) {
////        print(notification.userInfo)
//        let keyboardFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! CGRect
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
////        print(keyboardFrame)
//        containerViewBottomAnchor?.constant = -keyboardFrame.height
//        /* Everytime you want to animate constraints inside iOS, all you have to do is call self.view.layoutIfNeeded after you modify the constraint. */
//        UIView.animate(withDuration: keyboardDuration) { 
//            self.view.layoutIfNeeded()
//        }
//    }
//    
//    func handleKeyboardWillHide(notification: Notification) {
//        containerViewBottomAnchor?.constant = 0
//        let keyboardDuration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
//        UIView.animate(withDuration: keyboardDuration) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: chatMessageCellId, for: indexPath) as! ChatMessageCell
        
        cell.chatLogController = self
        
        let message = messages[indexPath.item]
        cell.message = message
        cell.textView.text = message.text
//        cell.backgroundColor = .blue
        
        setupCell(cell: cell, message: message)
        
        if let text = message.text {
            // 32 is a guess.
//            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 32
            cell.bubbleWidthAnchor?.constant = estimateFrameForText(text: text).width + 28
            cell.textView.isHidden = false
        } else if message.imageUrl != nil {
            cell.bubbleWidthAnchor?.constant = 200
            // We hide it so that the textView is not on top of the image so that we can interact and tap on the image to zoom it.
            cell.textView.isHidden = true
        }
        
//        if message.videoUrl != nil {
//            cell.playButton.isHidden = false
//        } else {
//            cell.playButton.isHidden = true
//        }
        
        cell.playButton.isHidden = message.videoUrl == nil
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingUrlString(urlString: profileImageUrl)
        }
        
        if message.fromId == Auth.auth().currentUser?.uid {
            // Outgoing blue.
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            // The reason we have to put it here as well is because cells do get reused, so we have to be careful about resetting the color.
            cell.textView.textColor = .white
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            cell.profileImageView.isHidden = true
        } else {
            // Incoming gray.
            cell.bubbleView.backgroundColor = ChatMessageCell.grayColor
            cell.textView.textColor = .black
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.profileImageView.isHidden = false
        }
        
        if let messageImageUrl = message.imageUrl {
            cell.messageImageView.loadImageUsingUrlString(urlString: messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        } else {
            cell.messageImageView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        let message = messages[indexPath.item]
        if let text = message.text {
//            height = estimateFrameForText(text: text).height + 20
            height = estimateFrameForText(text: text).height + 18
        } else if message.imageUrl != nil {
            if let imageHeight = message.imageHeight?.doubleValue, let imageWidth = message.imageWidth?.doubleValue {
                height = CGFloat(imageHeight / imageWidth * 200)
            }
            
        }
        let width = UIScreen.main.bounds.width
        // Need to use the above for when rotating landscape, or else it won't work.
//        return CGSize(width: view.frame.width, height: height)
        return CGSize(width: width, height: height)
    }
    
    private func estimateFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 16)]
        let frame = NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return frame
    }
    
//    lazy var inputTextField: UITextField = {
//        let textField = UITextField()
//        textField.placeholder = "Enter message..."
//        textField.translatesAutoresizingMaskIntoConstraints = false
//        textField.delegate = self
//        return textField
//    }()
    
//    var containerViewBottomAnchor: NSLayoutConstraint?
//    
//    private func setupInputComponents() {
//        let containerView = UIView()
//        containerView.backgroundColor = .white
////        containerView.backgroundColor = .red
//        containerView.translatesAutoresizingMaskIntoConstraints = false
//        
//        view.addSubview(containerView)
//        /* Even with the constraints below, the containerView is being pinned to the top and not the bottom for some weird reason. We could
//         change the type of the class to UIViewController from UITableViewController and that would pin it to the bottom. Or we could change
//         it to UICollectionViewController and that would make our lives easier. */
//        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        containerViewBottomAnchor = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
//        containerViewBottomAnchor?.isActive = true
//        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        
//        // Using type: .system makes the button look more interactive with flashing when you tap. If we create a button like UIButton() then it will be 100% plain.
//        let sendButton = UIButton(type: .system)
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
//        
//        containerView.addSubview(sendButton)
//        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
//        sendButton.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        sendButton.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
////        let inputTextField = UITextField()
////        inputTextField.placeholder = "Enter message..."
////        inputTextField.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(inputTextField)
//        inputTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
//        inputTextField.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
//        inputTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
//        inputTextField.heightAnchor.constraint(equalTo: containerView.heightAnchor).isActive = true
//        
//        let separatorLineView = UIView()
//        separatorLineView.backgroundColor = UIColor.rgb(red: 220, green: 220, blue: 220)
//        separatorLineView.translatesAutoresizingMaskIntoConstraints = false
//        
//        containerView.addSubview(separatorLineView)
//        separatorLineView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
//        separatorLineView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
//        separatorLineView.widthAnchor.constraint(equalTo: containerView.widthAnchor).isActive = true
//        separatorLineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
////        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
//        
//    }
    
    func handleSend() {
        guard let text = inputContainerView.inputTextField.text, text != "" else {
            print("empty text")
            return
        }
        let properties: [String: Any] = ["text": text]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithImageUrl(imageUrl: String, image: UIImage) {
        let properties: [String: Any] = ["imageUrl": imageUrl, "imageWidth": image.size.width, "imageHeight": image.size.height]
        sendMessageWithProperties(properties: properties)
    }
    
    private func sendMessageWithProperties(properties: [String: Any]) {
        let ref = Database.database().reference().child("messages")
        let childRef = ref.childByAutoId()
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
        var values: [String: Any] = ["fromId": fromId, "toId": toId, "timestamp": timestamp]
        // Adding properties to values. key $0, value $1
        properties.forEach({values[$0] = $1})
        //        childRef.updateChildValues(values)
        childRef.updateChildValues(values) { (error: Error?, reference: DatabaseReference) in
            if error != nil {
                print(error!)
                return
            }
            let userMessagesRef = Database.database().reference().child("user-messages").child(fromId).child(toId)
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId: 1])
            
            let recipientUserMessagesRef = Database.database().reference().child("user-messages").child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId: 1])
            
            self.inputContainerView.inputTextField.text = nil
        }
    }
    
//    // When we tap enter we execute this code.
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        handleSend()
//        return true
//    }
    
    var startingFrame: CGRect?
    var blackBackgroundView: UIView?
    var inputContainerViewBlock: UIView?
    var startingImageView: UIImageView?
    
    /* If you want to support landscape mode then you could use constraints insted of setting frames. */
    func performZoomInForStartingImageView(startingImageView: UIImageView) {
        self.startingImageView = startingImageView
        self.startingImageView?.isHidden = true
        // This is the frame inside the entire application. Absolute coordinates.
        startingFrame = startingImageView.superview?.convert(startingImageView.frame, to: nil)
//        print(startingFrame.width, startingFrame.height)
        let zoomingImageView = UIImageView(frame: startingFrame!)
        zoomingImageView.backgroundColor = .red
        zoomingImageView.layer.masksToBounds = true
        zoomingImageView.image = startingImageView.image
        zoomingImageView.isUserInteractionEnabled = true
        zoomingImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handeZoomOut)))
        if let window = UIApplication.shared.keyWindow {
            
            blackBackgroundView = UIView(frame: window.frame)
            blackBackgroundView?.backgroundColor = .black
            blackBackgroundView?.alpha = 0
            // Since we added it before zoomingImageView, it will appear behind it.
            window.addSubview(blackBackgroundView!)
            
            inputContainerViewBlock = UIView()
            inputContainerViewBlock?.frame = CGRect(x: 0, y: UIScreen.main.bounds.height - inputContainerView.frame.height, width: inputContainerView.frame.width, height: inputContainerView.frame.height)
            inputContainerViewBlock?.backgroundColor = .black
            inputContainerViewBlock?.alpha = 0
            // https://stackoverflow.com/questions/37078632/insert-subview-above-inputaccessoryview
            if let last = UIApplication.shared.windows.last {
                last.addSubview(inputContainerViewBlock!)
            }
            
            window.addSubview(zoomingImageView)
            let width = UIScreen.main.bounds.width
            let height = startingFrame!.height / startingFrame!.width * width
            let x: CGFloat = 0
//            let y = (UIScreen.main.bounds.height / 2) - (height / 2)
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                zoomingImageView.frame = CGRect(x: x, y: y, width: width, height: height)
                zoomingImageView.frame = CGRect(x: x, y: 0, width: width, height: height)
                // Can also set y value like this.
                zoomingImageView.center = window.center
                self.blackBackgroundView?.alpha = 1
                // Can also add another view to block the inputContainerView. It will look smoother.
//                self.inputContainerView.alpha = 0
                self.inputContainerViewBlock?.alpha = 1
            }, completion: nil)
        }
    }
    
    func handeZoomOut(tapGesture: UITapGestureRecognizer) {
        guard let zoomOutImageView = tapGesture.view as? UIImageView else {
            return
        }
        // https://stackoverflow.com/questions/5948167/uiview-animatewithduration-doesnt-animate-cornerradius-variation
        zoomOutImageView.layer.cornerRadius = 16
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            zoomOutImageView.frame = self.startingFrame!
            self.blackBackgroundView?.alpha = 0
            self.inputContainerViewBlock?.alpha = 0
        }) { (completed: Bool) in
            zoomOutImageView.removeFromSuperview()
            self.startingImageView?.isHidden = false
            self.blackBackgroundView?.removeFromSuperview()
            self.inputContainerViewBlock?.removeFromSuperview()
        }
    }
}



































