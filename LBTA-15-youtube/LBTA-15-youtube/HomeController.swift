//
//  ViewController.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class HomeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    private let homeCellId = "homeCellId"
    
    var videos: [Video] = {
        
        var kanyeChannel = Channel()
        kanyeChannel.name = "KanyeIsTheBestChannel"
        kanyeChannel.profileImageName = "kanye_profile"
        
        var blankSpaceVideo = Video()
        blankSpaceVideo.title = "Taylor Swift - Blank Space"
        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
        blankSpaceVideo.channel = kanyeChannel
        blankSpaceVideo.numberOfViews = 132423112
        
        var badBloodVideo = Video()
        badBloodVideo.title = "Taylor Swift - Bad Blood featuring Kendrick Lamar"
        badBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
        badBloodVideo.channel = kanyeChannel
        badBloodVideo.numberOfViews = 23432324212
        
        return [blankSpaceVideo, badBloodVideo]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Let this stay for now. I think it is needed when pushing views into navigation controller, the back button will show this title.
        navigationItem.title = "Home"
        navigationController?.navigationBar.isTranslucent = false
        // This needs to use frame instead of constraints for some reason, don'† know why.
        /* We subtract 32 to get the little spacing on the left side. The tutorial video used view.frame.height as height
         of the label, but that looks weird when testing with green background color as someone on the comment section mentioned.
         I followed his suggestion instead. But as Brian said, he does not trust navigationBar's bounds when it comes to custom
         views. Let's just use this until we hit some troubles. */
//        let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: view.frame.height))
        if let navigationHeight = navigationController?.navigationBar.frame.height {
            let titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width - 32, height: navigationHeight))
            titleLabel.text = "Home"
            titleLabel.textColor = UIColor.white
//            titleLabel.backgroundColor = UIColor.green
            titleLabel.font = UIFont.systemFont(ofSize: 18)
            navigationItem.titleView = titleLabel
            
        }
        
//        view.backgroundColor = UIColor.red
        collectionView?.backgroundColor = UIColor.white
        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: homeCellId)
        
        // You can set padding like this too.
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        // Ø: Also possible
//        collectionView?.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    private func setupNavBarButtons() {
        let searchImage = UIImage(named: "search_icon")?.withRenderingMode(.alwaysOriginal)
        let searchBarButtonItem = UIBarButtonItem(image: searchImage, style: .plain, target: self, action: #selector(handleSearch))
        
        let moreImage = UIImage(named: "nav_more_icon")?.withRenderingMode(.alwaysOriginal)
        let moreButton = UIBarButtonItem(image: moreImage, style: .plain, target: self, action: #selector(handleMore))
        
        // The ordering is important, think of it as floating right.
        navigationItem.rightBarButtonItems = [moreButton, searchBarButtonItem]
    }
    
    func handleSearch() {
//        print("search tapped")
    }
    
    func handleMore() {
        print("more tapped")
    }
    
    let menuBar: MenuBar = {
        let mb = MenuBar()
        return mb
    }()
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:|[v0(50)]", views: menuBar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! VideoCell
        cell.video = videos[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        /* Videos on YouTube are 16:9 ratio. */
        let imageHeight = (view.frame.width - 16 - 16) * (9 / 16)
        return CGSize(width: view.frame.width, height: imageHeight + 16 + 8 + 44 + 40 + 1)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        // Eliminates the actual space that we see between each one of the cells.
        return 0
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//    }
    
}









