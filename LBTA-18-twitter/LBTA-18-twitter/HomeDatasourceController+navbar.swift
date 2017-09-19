//
//  HomeDatasourceController+navbar.swift
//  LBTA-18-twitter
//
//  Created by Alexander Baran on 19/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

extension HomeDatasourceController {
    
    func setupNavigationBarItems() {
        setupLeftNavItem()
        setupRightNavItems()
        setupRemainingNavItems()
    }
    
    private func setupRemainingNavItems() {
        let titleImageView = UIImageView(image: UIImage(named: "title_icon"))
        titleImageView.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        titleImageView.contentMode = .scaleAspectFit
        navigationItem.titleView = titleImageView
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        // Remove the line or shadow from nav bar.
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        // Add our own line.
        
        let navBarSeparatorView = UIView()
        navBarSeparatorView.backgroundColor = UIColor(r: 230, g: 230, b: 230)
        
        view.addSubview(navBarSeparatorView)
        
        navBarSeparatorView.anchor(view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
    }
    
    private func setupLeftNavItem() {
        let followButton = UIButton(type: .system)
        let followButtonImage = UIImage(named: "follow")?.withRenderingMode(.alwaysOriginal)
        followButton.setImage(followButtonImage, for: .normal)
        followButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: followButton)
    }
    
    private func setupRightNavItems() {
        let searchButton = UIButton(type: .system)
        let searchButtonImage = UIImage(named: "search")?.withRenderingMode(.alwaysOriginal)
        searchButton.setImage(searchButtonImage, for: .normal)
        searchButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        let composeButton = UIButton(type: .system)
        let composeButtonImage = UIImage(named: "compose")?.withRenderingMode(.alwaysOriginal)
        composeButton.setImage(composeButtonImage, for: .normal)
        composeButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(customView: composeButton),
            UIBarButtonItem(customView: searchButton)
        ]
    }
    
}
