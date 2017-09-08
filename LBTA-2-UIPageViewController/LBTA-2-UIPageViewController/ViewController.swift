//
//  ViewController.swift
//  LBTA-2-UIPageViewController
//
//  Created by Alexander Baran on 19/08/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class ProjectorPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    override func viewDidLoad() {
        // Always call super here.
        super.viewDidLoad()
        
        // This is an important property that we have to set.
        dataSource = self
        
        view.backgroundColor = UIColor.white
        
        let frameViewController = FrameViewController()
//        frameViewController.imageView.image = UIImage(named: imageNames.first!)
        frameViewController.imageName = imageNames.first
        let viewControllers = [frameViewController]
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    let imageNames = ["puppy1", "puppy2", "puppy3"]
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // viewController is the current UIViewController that is passed as a parameter.
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imageNames.index(of: currentImageName!)!
        
        if currentIndex < imageNames.count - 1 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imageNames[currentIndex + 1]
            return frameViewController
        }
        
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        let currentImageName = (viewController as! FrameViewController).imageName
        let currentIndex = imageNames.index(of: currentImageName!)!
        
        if currentIndex > 0 {
            let frameViewController = FrameViewController()
            frameViewController.imageName = imageNames[currentIndex - 1 ]
            return frameViewController
        }
        
        return nil
    }
}

class FrameViewController: UIViewController {
    
    var imageName: String? {
        didSet {
            imageView.image = UIImage(named: imageName!)
        }
    }
    
    let imageView: UIImageView = {
       let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
//        iv.backgroundColor = UIColor.blue
//        iv.image = UIImage(named: "puppy1")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.black
        
        view.addSubview(imageView)

        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

