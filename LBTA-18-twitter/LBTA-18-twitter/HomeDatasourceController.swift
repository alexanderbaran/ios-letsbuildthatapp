//
//  HomeDatasourceController.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 18/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import LBTAComponents
import TRON
import SwiftyJSON

class HomeDatasourceController: DatasourceController {
    
    let errorMessageLabel: UILabel = {
        let label = UILabel()
        label.text = "Apologies something went wrong. Please try again later..."
        label.textAlignment = .center
        label.numberOfLines = 2
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(errorMessageLabel)
        errorMessageLabel.fillSuperview()
        
        collectionView?.backgroundColor = UIColor(r: 232, g: 236, b: 241)
        
        setupNavigationBarItems()
        
//        let homeDatasource = HomeDatasource()
//        self.datasource = homeDatasource
        
//        fetchHomeFeed()
//        Service.sharedInstance.fetchHomeFeed(onSuccess: { (homeDatasource: HomeDatasource) in
//            self.datasource = homeDatasource
//            self.errorMessageLabel.isHidden = true
//        }, onError: {
//            self.errorMessageLabel.isHidden = false
//        })
        
        Service.sharedInstance.fetchHomeFeed(completion: { (homeDatasource: HomeDatasource?, error: Error?) in
            if error != nil {
                print(error!)
                self.errorMessageLabel.isHidden = false
                if let apiError = error as? APIError<Service.JSONError> {
                    if apiError.response?.statusCode != 200 {
                        self.errorMessageLabel.text = "Status code was not 200"
                    }
                }
                return
            }
            self.datasource = homeDatasource
            self.errorMessageLabel.isHidden = true
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
//        collectionViewLayout.invalidateLayout()
    }
    
//    let tron = TRON(baseURL: "https://api.letsbuildthatapp.com")
    
//    class Home: JSONDecodable {
//        
//        var users: [User]
//        
//        required init(json: JSON) throws {
////            print("Now ready to parse json: \n", json)
//            users = [User]()
//            let array = json["users"].array
//            for userJson in array! {
//                let name = userJson["name"].stringValue
//                let username = userJson["username"].stringValue
//                let bio = userJson["bio"].stringValue
//                
//                let user = User(name: name, username: username, bioText: bio, profileImage: "")
//                users.append(user)
//            }
//        }
//    }

//    fileprivate func fetchHomeFeed() {
//
//    }
//    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            guard let user = self.datasource?.item(indexPath) as? User else { return .zero }
            return CGSize(width: view.frame.width, height: estimatedHeightForText(text: user.bioText) + 12 + 20 + 20 + 14)
        } else if indexPath.section == 1 {
            guard let tweet = datasource?.item(indexPath) as? Tweet else { return .zero }
            return CGSize(width: view.frame.width, height: estimatedHeightForText(text: tweet.message) + 12 + 20 + 20 + 22)
        }
        return CGSize(width: view.frame.width, height: 200)
        // Using this here produced confusion/bug that I used more than 20 minutes to figure out.
//        return .zero
    }
    
    private func estimatedHeightForText(text: String) -> CGFloat {
        // Had to add additional 4 and 2 for textView has extra padding for the width.
        let approximateWidthOfBioTextView = view.frame.width - 12 - 50 - 8 - 4 - 2
        let size = CGSize(width: approximateWidthOfBioTextView, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
        let attributes = [NSFontAttributeName: UIFont.systemFont(ofSize: 15)]
        let estimatedFrame = NSString(string: text).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return estimatedFrame.height
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if section == 1 {
            return .zero
        }
        return CGSize(width: view.frame.width, height: 64)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}





















