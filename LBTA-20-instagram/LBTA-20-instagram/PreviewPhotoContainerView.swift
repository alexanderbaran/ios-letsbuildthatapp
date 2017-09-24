//
//  PreviewPhotoContainerView.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 24/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import Photos

class PreviewPhotoContainerView: UIView {
    
    let previewImageView: UIImageView = {
        let iv = UIImageView()
        return iv
    }()
    
    lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "cancel_shadow")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleCancel), for: .touchUpInside)
        return button
    }()
    
    lazy var saveButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "save_shadow")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleSave), for: .touchUpInside)
        return button
    }()
    
    let savedLabel: UILabel = {
        let label = UILabel()
        label.text = "Saved Successfully"
        label.textColor = .white
        label.backgroundColor = UIColor(white: 0, alpha: 0.6)
        label.layer.cornerRadius = 10
        label.clipsToBounds = true
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    func handleSave() {
        // TODO: pan slide the camera view downwards out of the screen.
        guard let previewImage = previewImageView.image else { return }
        // Saving images to your photo album.
        let library = PHPhotoLibrary.shared()
        library.performChanges({
            PHAssetChangeRequest.creationRequestForAsset(from: previewImage)
        }) { (success: Bool, error: Error?) in
            if error != nil {
                print("Failed to save image to photo library:", error!)
                return
            }
            print("Successfully saved image to library.")
            // Saving the photo on to some kind of different thread. Need to get on the main thread.
            DispatchQueue.main.async {
                self.addSubview(self.savedLabel)
                // Easier to specify frames when we animating in and out of a view.
                self.savedLabel.frame = CGRect(x: 0, y: 0, width: 200, height: 80)
                self.savedLabel.center = self.center // CGPoint
                
                // Starts off as a zero scaled rectangle.
                self.savedLabel.layer.transform = CATransform3DMakeScale(0, 0, 0)
                
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                    /* transform is a CATransform3D object. */
                    self.savedLabel.layer.transform = CATransform3DMakeScale(1, 1, 1)
                }, completion: { (completed: Bool) in
                    UIView.animate(withDuration: 0.5, delay: 1, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        self.savedLabel.layer.transform = CATransform3DMakeScale(0.1, 0.1, 0.1) // 0, 0, 0 does not work as intended.
                        self.savedLabel.alpha = 0
                    }, completion: { (_) in // Underscore if we do not need the completed: Bool variable.
                        self.savedLabel.removeFromSuperview()
                    })
                })
            }
        }
    }
    
    func handleCancel() {
        self.removeFromSuperview()
    }
    
    private func setupViews() {
        addSubview(previewImageView)
        addSubview(cancelButton)
        addSubview(saveButton)
        previewImageView.fillSuperview()
        cancelButton.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: nil, topConstant: 12, leftConstant: 12, bottomConstant: 0, rightConstant: 0, widthConstant: 50, heightConstant: 50)
        saveButton.anchor(top: nil, left: leftAnchor, bottom: bottomAnchor, right: nil, topConstant: 0, leftConstant: 24, bottomConstant: -24, rightConstant: 0, widthConstant: 50, heightConstant: 50)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
















