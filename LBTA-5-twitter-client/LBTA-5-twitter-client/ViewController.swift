//
//  ViewController.swift
//  LBTA-5-twitter-client
//
//  Created by Alexander Baran on 06/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

struct HomeStatus {
    var text: String?
    var profileImageUrl: String?
    var name: String?
    var screenName: String?
}

class ViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    static let cellId = "cellId"
    
    var homeStatuses: [HomeStatus]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Twitter Home"
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(StatusCell.self, forCellWithReuseIdentifier: ViewController.cellId)
        
        let twitter = STTwitterAPI.init(
            oAuthConsumerKey: "f5aQRqZG739K8sqeX8tVzBKd2",
            consumerSecret: "eXjwIdI1oxCcsKysmB6u8Om0IP0754L3wZg6rz9NSEAfKY4q0s",
            oauthToken: "905703091797987329-BPzGRb0wkZdpfOPKRHQN6L7JFaboAGF",
            oauthTokenSecret: "UqEduXDbTJnojXgycIxVOUMu1NRip83WwIbLa1RpFDz98"
        )
        
        // Command click verifyCredentials to find out more.
        twitter?.verifyCredentials(userSuccessBlock: { (username: String?, userID: String?) in
//            print(username!, userID!)
            
            // https://stackoverflow.com/questions/37843049/xcode-8-swift-3-expression-of-type-uiviewcontroller-is-unused-warning
            _ = twitter?.getHomeTimeline(sinceID: nil, count: 10, successBlock: { (statuses: [Any]?) in
                
                // self keyword because inside closure.
                self.homeStatuses = [HomeStatus]()
                
                for status in statuses! {
                    let status = status as? NSDictionary
                    let text = status?["text"] as? String
                    
                    if let user = status?["user"] as? NSDictionary {
                        let profileImage = user["profile_image_url_https"] as? String
                        let screenName = user["screen_name"] as? String
                        let name = user["name"] as? String
                        
                        self.homeStatuses?.append(HomeStatus(text: text, profileImageUrl: profileImage, name: name, screenName: screenName))
                    }
                }

                // The API calls this on the main thread so do not actually need DispatchQueue.main.async.
                self.collectionView?.reloadData()
                
//                DispatchQueue.main.async {
//                    self.collectionView?.reloadData()
//                }
                
            }, errorBlock: { (error: Error?) in
                print(error!)
            })
            
        }, errorBlock: { (error: Error?) in
            print(error!)
        })
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return (homeStatuses?.count)!
        if let count = homeStatuses?.count {
            return count
        }
        return 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let statusCell = collectionView.dequeueReusableCell(withReuseIdentifier: ViewController.cellId, for: indexPath) as! StatusCell
        if let homeStatus = homeStatuses?[indexPath.item] {
            statusCell.homeStatus = homeStatus
        }
        return statusCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if let homeStatus = homeStatuses?[indexPath.item] {
            if let name = homeStatus.name, let screenName = homeStatus.screenName, let text = homeStatus.text {
                
                let attributedText = NSMutableAttributedString(string: name, attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14)
                    ])
                
                attributedText.append(NSAttributedString(string: "\n@\(screenName)", attributes: [
                    NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)
                    ]))
                
                attributedText.append(NSAttributedString(string: "\n\(text)", attributes: [
                    NSFontAttributeName: UIFont.systemFont(ofSize: 14)
                    ]))
                
                // height can be anything here inside CGSize. I think the 80 is to compensate for the left image and side margins.
                let size = attributedText.boundingRect(with: CGSize(width: view.frame.width - 80, height: 1000), options: NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin), context: nil).size
                
                // Add 20 to match the bottom of the text view.
                return CGSize(width: view.frame.width, height: size.height + 20)
            }
        }
        
        return CGSize(width: view.frame.width, height: 80)
    }


}

class StatusCell: UICollectionViewCell {
    
    // Computer property.
    var homeStatus: HomeStatus? {
        didSet {
            if let profileImageUrl = homeStatus?.profileImageUrl {
                
                if let name = homeStatus?.name, let screenName = homeStatus?.screenName, let text = homeStatus?.text {
                    
                    let attributedText = NSMutableAttributedString(string: name, attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14)
                    ])
                    
                    attributedText.append(NSAttributedString(string: "\n@\(screenName)", attributes: [
                        NSFontAttributeName: UIFont.boldSystemFont(ofSize: 14)
                    ]))
                    
                    attributedText.append(NSAttributedString(string: "\n\(text)", attributes: [
                        NSFontAttributeName: UIFont.systemFont(ofSize: 14)
                    ]))
                    
                    statusTextView.attributedText = attributedText
                }

                
                // We should include cache here instead of constantly loading the image.
                let url = URL(string: profileImageUrl)
                URLSession.shared.dataTask(with: url!, completionHandler: { (data: Data?, response: URLResponse?, error: Error?) in
                    
                    if error != nil {
                        print(error!)
                        return
                    }
                    
//                    print("loaded image")
                    
                    let image = UIImage(data: data!)
                    // Call it on main UI thread.
                    DispatchQueue.main.async {
                        // self keyword because of closure.
                        self.profileImageView.image = image
                    }
                    
                }).resume()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let statusTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        return textView
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
//        imageView.backgroundColor = UIColor.red
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    func setupViews() {
        addSubview(statusTextView)
        addSubview(dividerView)
        addSubview(profileImageView)
        
        // constraints for statusTextView
        addConstraintsWithFormat(format: "H:|-8-[v0(48)]-8-[v1]|", views: profileImageView, statusTextView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: statusTextView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(48)]", views: profileImageView)
        
        // constraints for dividerView
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: dividerView)
        addConstraintsWithFormat(format: "V:[v0(1)]|", views: dividerView)
    }
}

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
