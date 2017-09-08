//
//  ViewController.swift
//  LBTA-10-core-animation
//
//  Created by Alexander Baran on 08/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

//    let zoomImageView = UIView()
    let zoomImageView = UIImageView()
    let startingFrame = CGRect(x: 0, y: 0, width: 200, height: 100)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Image views by default has user interaction disabled.
        zoomImageView.isUserInteractionEnabled = true
        zoomImageView.frame = startingFrame
//        zoomImageView.backgroundColor = UIColor.red
        zoomImageView.image = UIImage(named: "zuckdog")
        zoomImageView.contentMode = .scaleAspectFill
        // https://stackoverflow.com/questions/20449256/how-does-clipstobounds-work
        zoomImageView.clipsToBounds = true
        
        zoomImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.animate)))
        
        
        view.addSubview(zoomImageView)
    }
    
    func animate() {
        UIView.animate(withDuration: 0.75) {
            let height = (self.view.frame.width / self.startingFrame.width) * self.startingFrame.height
            let y = (self.view.frame.height / 2) - (height / 2)
            self.zoomImageView.frame = CGRect(x: 0, y: y, width: self.view.frame.width, height: height)
        }
    }

}

