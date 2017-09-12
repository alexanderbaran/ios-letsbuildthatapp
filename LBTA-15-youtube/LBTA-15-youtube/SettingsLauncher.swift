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
            Setting(name: .settings, imageName: "settings"),
            Setting(name: .termsPrivacy, imageName: "privacy"),
            Setting(name: .sendFeedback, imageName: "feedback"),
            Setting(name: .help, imageName: "help"),
            Setting(name: .switchAccount, imageName: "switch_account"),
            Setting(name: .cancel, imageName: "cancel")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let setting = settings[indexPath.item]
//        print(setting.name)
//        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//            self.blackView.alpha = 0
//            if let window = UIApplication.shared.keyWindow {
//                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
//            }
//        }) { (completed: Bool) in
//            let setting = self.settings[indexPath.item]
//            if setting.name != "Cancel" {
//                self.homeController?.showControllerForSettings(setting: setting)
//            }
//        }
        // Tutorial way did not work and gave errors.
        let setting = self.settings[indexPath.item]
        handleDismiss(sender: setting)
    }
    
    let blackView = UIView()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        return cv
    }()
    
    var homeController: HomeController?

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
            // https://stackoverflow.com/questions/28794332/swift-default-parameter-selector-syntax
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        }
    }
    
    // Tutorial way gave errors because handleDismiss could not take in Setting type as argument. Had to improvise.
    // https://stackoverflow.com/questions/33443570/passing-parameters-to-a-selector-in-swift
    func handleDismiss(sender: AnyObject) {
//        // https://stackoverflow.com/questions/24006165/how-do-i-print-the-type-or-class-of-a-variable-in-swift
//        if let tapGesture = sender as? UITapGestureRecognizer {
//            let type = type(of: tapGesture.self)
//            print("sender is actually a \(type)")
//        }
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blackView.alpha = 0
            if let window = UIApplication.shared.keyWindow {
                self.collectionView.frame = CGRect(x: 0, y: window.frame.height, width: self.collectionView.frame.width, height: self.collectionView.frame.height)
            }
        }) { (completed: Bool) in
            if let setting = sender as? Setting {
                if setting.name != .cancel {
                    self.homeController?.showControllerForSettings(setting: setting)
                }
            }
//            if setting.name != "Cancel" {
//                self.homeController?.showControllerForSettings(setting: setting)
//            }
        }
    }
}





