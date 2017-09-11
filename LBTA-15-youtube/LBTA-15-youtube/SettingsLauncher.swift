//
//  SettingsLauncher.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 11/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class SettingsLauncher: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private let settingCellId = "settingsCellId"
    private let settingsCellHeight: CGFloat = 50
    
    private let settings: [Setting] = {
        return [
            Setting(name: "Settings", imageName: "settings"),
            Setting(name: "Terms & privacy policy", imageName: "privacy"),
            Setting(name: "Send Feedback", imageName: "feedback"),
            Setting(name: "Help", imageName: "help"),
            Setting(name: "Switch Account", imageName: "switch_account"),
            Setting(name: "Cancel", imageName: "cancel")
        ]
    }()
    
    override init() {
        super.init()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(SettingCell.self, forCellWithReuseIdentifier: settingCellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: settingCellId, for: indexPath) as! SettingCell
        cell.setting = settings[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: settingsCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()

    func showSettings() {
        //        print("more tapped")
        if let window = UIApplication.shared.keyWindow {
            blackView.backgroundColor = UIColor(white: 0, alpha: 0.5)
            window.addSubview(blackView)
            // collectionView has to come after the blackView or else it will be behind it. That is how the priority works.
            window.addSubview(collectionView)
            let menuHeight: CGFloat = settingsCellHeight * CGFloat(settings.count)
            let y = window.frame.height - menuHeight
            collectionView.frame = CGRect(x: 0, y: window.frame.height, width: window.frame.width, height: menuHeight)
            blackView.frame = window.frame
            blackView.alpha = 0
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.blackView.alpha = 1
                self.collectionView.frame = CGRect(x: 0, y: y, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }, completion: nil)
            // https://stackoverflow.com/questions/35637041/how-does-uibutton-addtarget-self-work
            // https://stackoverflow.com/questions/6502843/buttons-target-is-always-self-can-i-set-to-be-another?rq=1
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        }
    }
    
    func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }, completion: nil)
    }
}
