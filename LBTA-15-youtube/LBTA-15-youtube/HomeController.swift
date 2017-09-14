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
    private let feedCellId = "feedCellId"
    
    let titles = ["Home", "Trending", "Subscriptions", "Account"]
    
//    var videos: [Video] = {
//        
//        var kanyeChannel = Channel()
//        kanyeChannel.name = "KanyeIsTheBestChannel"
//        kanyeChannel.profileImageName = "kanye_profile"
//        
//        var blankSpaceVideo = Video()
//        blankSpaceVideo.title = "Taylor Swift - Blank Space"
//        blankSpaceVideo.thumbnailImageName = "taylor_swift_blank_space"
//        blankSpaceVideo.channel = kanyeChannel
//        blankSpaceVideo.numberOfViews = 132423112
//        
//        var badBloodVideo = Video()
//        badBloodVideo.title = "Taylor Swift - Bad Blood featuring Kendrick Lamar"
//        badBloodVideo.thumbnailImageName = "taylor_swift_bad_blood"
//        badBloodVideo.channel = kanyeChannel
//        badBloodVideo.numberOfViews = 23432324212
//        
//        return [blankSpaceVideo, badBloodVideo]
//    }()
    
//    var videos: [Video]?
    
//    func fetchVideos() {
//        ApiService.sharedInstance.fetchVideos { (videos: [Video]) in
//            self.videos = videos
//            self.collectionView?.reloadData()
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        fetchVideos()
        
        // Let this stay for now. I think it is needed when pushing views into navigation controller, the back button will show this title.
//        navigationItem.title = "Home"
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
        
        setupCollectionView()
        
        setupMenuBar()
        setupNavBarButtons()
    }
    
    private func setupCollectionView() {
        // Can also get the layout like this.
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        //        view.backgroundColor = UIColor.red
        collectionView?.backgroundColor = UIColor.white
//        collectionView?.register(VideoCell.self, forCellWithReuseIdentifier: homeCellId)
//        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        collectionView?.register(FeedCell.self, forCellWithReuseIdentifier: feedCellId)
        
        // You can set padding like this too.
        collectionView?.contentInset = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
        
        collectionView?.isPagingEnabled = true
        
        // Ø: Also possible
        //        collectionView?.frame = CGRect(x: 0, y: 50, width: view.frame.width, height: view.frame.height - 50)
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
        scrollToMenuIndex(menuIndex: 2)
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = IndexPath(item: menuIndex, section: 0)
        collectionView?.scrollToItem(at: indexPath, at: [], animated: true)
        setTitleForIndex(index: menuIndex)
    }
    
    private func setTitleForIndex(index: Int) {
        if let titlelabel = navigationItem.titleView as? UILabel {
            titlelabel.text = titles[index]
        }
    }
    
//    let settingsLauncher = SettingsLauncher()
    /* Inside of a lazy var we are not actually executing this code everytime a view controller or anytime a class is being instantiated. It
     gets called only when it is needed. Also the code inside this block only gets called once if the settingsLauncher variable is nil. */
    lazy var settingsLauncher: SettingsLauncher = {
        let launcher = SettingsLauncher()
        launcher.homeController = self
        return launcher
    }()
    
    func handleMore() {
//        settingsLauncher.homeController = self
        settingsLauncher.showSettings()
//        showControllerForSettings()
    }
    
    func showControllerForSettings(setting: Setting) {
        let dummySettingsViewController = UIViewController()
        dummySettingsViewController.view.backgroundColor = UIColor.white
        dummySettingsViewController.navigationItem.title = setting.name.rawValue

        navigationController?.navigationBar.tintColor = UIColor.white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        navigationController?.pushViewController(dummySettingsViewController, animated: true)
    }
    
//    let blackView = UIView()
//    
//    func handleMore() {
////        print("more tapped")
//        if let window = UIApplication.shared.keyWindow {
//            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
//            window.addSubview(blackView)
//            blackView.frame = window.frame
//            blackView.alpha = 0
//            UIView.animate(withDuration: 0.5, animations: { 
//                self.blackView.alpha = 1
//            })
//            // https://stackoverflow.com/questions/35637041/how-does-uibutton-addtarget-self-work
//            // https://stackoverflow.com/questions/6502843/buttons-target-is-always-self-can-i-set-to-be-another?rq=1
//            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
//        }
//    }
//    
//    func handleDismiss() {
//        UIView.animate(withDuration: 0.5) { 
//            self.blackView.alpha = 0
//        }
//    }
    
    lazy var menuBar: MenuBar = {
        let mb = MenuBar()
        mb.homeController = self
        return mb
    }()
    
    private func setupMenuBar() {
        navigationController?.hidesBarsOnSwipe = true
        
        let redView = UIView()
        redView.backgroundColor = UIColor.rgb(red: 230, green: 32, blue: 31)
//        redView.backgroundColor = UIColor.green
        view.addSubview(redView)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: redView)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: redView)
        
        view.addSubview(menuBar)
        view.addConstraintsWithFormat(format: "H:|[v0]|", views: menuBar)
        view.addConstraintsWithFormat(format: "V:[v0(50)]", views: menuBar)
        
        menuBar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
//        menuBar.collectionView.selectItem(at: IndexPath(item: 1, section: 0), animated: true, scrollPosition: [])
        setTitleForIndex(index: Int(index))
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset.x)
        menuBar.horizontalBarViewLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: feedCellId, for: indexPath) as! FeedCell
//        let colors: [UIColor] = [.blue, .green, UIColor.gray, UIColor.purple]
//        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 50 comes from the size of the menuBar.
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
////        if let count = videos?.count {
////            return count
////        }
////        return 0
//        // This is also possible.
//        return videos?.count ?? 0
//    }
//    
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCellId, for: indexPath) as! VideoCell
//        cell.video = videos?[indexPath.item]
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        /* Videos on YouTube are 16:9 ratio. */
//        let imageHeight = (view.frame.width - 16 - 16) * (9 / 16)
//        return CGSize(width: view.frame.width, height: imageHeight + 16 + 8 + 44 + 40 + 1)
//    }
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        // Eliminates the actual space that we see between each one of the cells.
//        return 0
//    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 50, left: 0, bottom: 0, right: 0)
//    }
    
}









