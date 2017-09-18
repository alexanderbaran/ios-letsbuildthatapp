//
//  ViewController.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 17/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let pageCellId = "pageCellId"
    private let loginCellId = "loginCellId"
    
    private let pages: [Page] = {
        return [
            Page(title: "Share a great listen", message: "It's free to send your books to the people in your life. Every recipient's first book is on us.", imageName: "page1"),
            Page(title: "Send from your library", message: "Tap the More menu next to any book. Choose \"Send this Book\"", imageName: "page2"),
            Page(title: "Send from the player", message: "Tap the More menu in the upper corner. Choose \"Send this Book\"", imageName: "page3")
        ]
    }()
    
//    private let orangeColor = UIColor.rgb(red: 247, green: 154, blue: 27)
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.pageIndicatorTintColor = UIColor(white: 0.8, alpha: 1)
        pc.currentPageIndicatorTintColor = CustomColor.orange
        pc.numberOfPages = self.pages.count + 1
        return pc
    }()
    
    lazy var skipButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(CustomColor.orange, for: .normal)
        button.addTarget(self, action: #selector(skip), for: .touchUpInside)
        return button
    }()
    
    func skip() {
        pageControl.currentPage = pages.count - 1
        nextPage()
    }
    
    lazy var nextButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Next", for: .normal)
        button.setTitleColor(CustomColor.orange, for: .normal)
        button.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        return button
    }()
    
    func nextPage() {
        if pageControl.currentPage == pages.count {
            return
        }
        // Seconds last page.
        if pageControl.currentPage == pages.count - 1 {
            moveControlConstraintsOffScreen()
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                // Re lays out the contraints.
                self.view.layoutIfNeeded()
            }, completion: nil)
        }
//        print("next")
        // item for collection view and row for tableview, a convention.
        let indexPath = IndexPath(item: pageControl.currentPage + 1, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        pageControl.currentPage += 1
    }
    
    lazy var collectionView: UICollectionView = {
        // You need UICollectionViewFlowLayout and not UICollectionViewLayout, or else you will spend 20 minutes like last time figuring out why cells won'† show.
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        // The frame is .zero which is a zero frame.
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        // https://stackoverflow.com/questions/30836571/how-to-hide-scroll-bar-of-uicollectionview/30838627
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var pageControlBottomAnchor: NSLayoutConstraint?
    var skipButtonTopAnchor: NSLayoutConstraint?
    var nextButtonTopAnchor: NSLayoutConstraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        observeKeyboardNotifications()
        
        view.addSubview(collectionView)
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        view.addSubview(nextButton)
        // Using frames is not a good idea if you want to rotate your screen. Better to use constraints.
//        collectionView.frame = view.frame
        collectionView.anchorTo(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        
        //  The reason why we return the index of 1 is because top is nil so top is not added to the array. 0 is left, and 1 is bottom.
        pageControlBottomAnchor = pageControl.anchor(nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 40)[1]
        
        skipButtonTopAnchor = skipButton.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50)[0]
        
        nextButtonTopAnchor = nextButton.anchor(view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 16, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 60, heightConstant: 50).first
        
        
        registerCells()
    }
    
    private func observeKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardShow), name: Notification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardShow() {
//        print("keyboard shown")
        let y: CGFloat = UIDevice.current.orientation.isLandscape ? -110 : -60
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            // Move the whole view by 60 pixels upwards.
            self.view.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func keyboardHide() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }
    
    // Can also use scrollViewDidEndDragging, but scrollViewWillEndDragging will provide better feedback for whenever the dot needs to change to the next one.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageNumber = Int(targetContentOffset.pointee.x / view.frame.width)
//        print(pageNumber)
//        print(targetContentOffset.pointee.x)
        pageControl.currentPage = pageNumber
        if pageNumber == pages.count {
            moveControlConstraintsOffScreen()
        } else {
            pageControlBottomAnchor?.constant = 0
            skipButtonTopAnchor?.constant = 16
            nextButtonTopAnchor?.constant = 16
        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func moveControlConstraintsOffScreen() {
        // It does not matter whether the sign is - or not in the Extension because that just counts for inital value when you call the function. If you set it like this with the property then nothing in that function in the extension matters. And this all makes sense and you should remove the minus signs to avoid confusion.
        pageControlBottomAnchor?.constant = 40
        skipButtonTopAnchor?.constant = -50
        nextButtonTopAnchor?.constant = -50
    }
    
    // fileprivate is Swift 3 syntax for private.
    // https://stackoverflow.com/questions/27713749/private-static-variable-in-struct
    fileprivate func registerCells() {
        collectionView.register(PageCell.self, forCellWithReuseIdentifier: pageCellId)
        collectionView.register(LoginCell.self, forCellWithReuseIdentifier: loginCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pages.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == pages.count {
            // We are on the last page.
            let loginCell = collectionView.dequeueReusableCell(withReuseIdentifier: loginCellId, for: indexPath)
            return loginCell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: pageCellId, for: indexPath) as! PageCell
        let page = pages[indexPath.item]
        cell.page = page
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
//        print(UIDevice.current.orientation.isLandscape)
        collectionView.collectionViewLayout.invalidateLayout()
        
        // We have to center the pages manually.
        let indexPath = IndexPath(item: pageControl.currentPage, section: 0)
        DispatchQueue.main.async {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
            // To reset the images for landscape.
            self.collectionView.reloadData()
        }
    }
}





















