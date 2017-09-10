//
//  AppDetailController.swift
//  LBTA-13-app-store
//
//  Created by Alexander Baran on 09/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

let appDetailHeaderId = "appDetailHeaderId"
let screenshotsCellId = "screenshotsCellId"
let appDetailDescriptionCellId = "appDetailDescriptionCellId"

class AppDetailController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var app: App? {
        didSet {
            
            /* If we put a breakpoint at self.app = appDetail, it keeps calling itself and that is because we are cyclicly, constantly calling
             this setter by setting app variable which calls this didSet and then it continuously calls itself firing off this api service
             infinitely in an infite loop. We can fix it by adding something like below. */
            if app?.screenshots != nil {
                return
            }
            
            guard let id = app?.id else {
                print("app?.id failed")
                return
            }
            
            let urlString = "https://api.letsbuildthatapp.com/appstore/appdetail?id=\(id)"
            let url = URL(string: urlString)!
            let task = URLSession.shared.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
                if error != nil {
                    print(error!)
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String: Any]
                    let appDetail = App()
                    appDetail.setValuesForKeys(json)
                    
                    self.app = appDetail

                    DispatchQueue.main.async {
                        self.collectionView?.reloadData()
                    }
                } catch let error {
                    print(error)
                }
            }
            
            task.resume()
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(AppDetailHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: appDetailHeaderId)
        collectionView?.register(ScreenshotsCell.self, forCellWithReuseIdentifier: screenshotsCellId)
        collectionView?.register(AppDetailDescriptionCell.self, forCellWithReuseIdentifier: appDetailDescriptionCellId)
        
        collectionView?.alwaysBounceVertical = true
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: appDetailHeaderId, for: indexPath) as! AppDetailHeader
        header.app = app
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 170)
    }
    
    private func descriptionAttributedText() -> NSAttributedString {
        let attributedText = NSMutableAttributedString(string: "Description\n", attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 14)])
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        
        let range = NSMakeRange(0, attributedText.string.characters.count)
        attributedText.addAttribute(NSParagraphStyleAttributeName, value: style, range: range)
        
        if let desc = app?.desc {
            attributedText.append(NSAttributedString(string: desc, attributes: [
                NSFontAttributeName: UIFont.systemFont(ofSize: 11),
                NSForegroundColorAttributeName: UIColor.darkGray
            ]))
        }
        return attributedText
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.item == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: appDetailDescriptionCellId, for: indexPath) as! AppDetailDescriptionCell
            cell.textView.attributedText = descriptionAttributedText()
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: screenshotsCellId, for: indexPath) as! ScreenshotsCell
        cell.app = app
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.item == 1 {
            // Width of the text is view.frame.widt minus the text padding from the contrainsts, 8 on each side. Height can just be something large like 1000.
            let dummySize = CGSize(width: view.frame.width - 8 - 8, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(NSStringDrawingOptions.usesLineFragmentOrigin)
            let rect = descriptionAttributedText().boundingRect(with: dummySize, options: options, context: nil)
            // Most of the time this calculation is not going to be perfect. Text is sometimes getting cut at the bottom, so just add something like 30 pixels.
            return CGSize(width: view.frame.width, height: rect.height + 30)
        }
        
        return CGSize(width: view.frame.width, height: 170)
    }

}

class AppDetailHeader: BaseCell {
    
    var app: App? {
        didSet {
            if let imageName = app?.imageName {
                imageView.image = UIImage(named: imageName)
            }
            if let name = app?.name {
                nameLabel.text = name
            }
            if let price = app?.price?.stringValue {
                buyButton.setTitle("$\(price)", for: .normal)
            }
        }
    }
    
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
//        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = UIColor.yellow
        iv.layer.cornerRadius = 16
        // cornerRadius does not work if masksToBounds is not set to true.
        iv.layer.masksToBounds = true
        return iv
    }()
    
    let segmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Details", "Reviews", "Related"])
        sc.tintColor = UIColor.darkGray
        sc.selectedSegmentIndex = 0
//        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "TEST"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let buyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("BUY", for: .normal)
        button.layer.borderColor = UIColor(red: 0, green: 129/255, blue: 250/255, alpha: 1).cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerLineView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()

//        backgroundColor = UIColor.blue
        
        addSubview(imageView)
        addSubview(segmentedControl)
        addSubview(nameLabel)
        addSubview(buyButton)
        addSubview(dividerLineView)
        
        addConstraintsWithFormat(format: "H:|-14-[v0(100)]-8-[v1]|", views: imageView, nameLabel)
        addConstraintsWithFormat(format: "V:|-14-[v0(100)]", views: imageView)
        
        addConstraintsWithFormat(format: "H:|-40-[v0]-40-|", views: segmentedControl)
        addConstraintsWithFormat(format: "V:[v0(32)]-14-[v1(34)]-8-|", views: buyButton, segmentedControl)
        
        addConstraintsWithFormat(format: "V:|-14-[v0(20)]", views: nameLabel)
        
        addConstraintsWithFormat(format: "H:[v0(60)]-14-|", views: buyButton)
        
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerLineView)
        addConstraintsWithFormat(format: "V:[v0(0.5)]|", views: dividerLineView)
        
        
    }
}

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
