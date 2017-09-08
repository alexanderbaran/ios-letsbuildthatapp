//
//  ViewController.swift
//  LBTA-1-UICollectionView
//
//  Created by Alexander Baran on 13/08/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//


/* Delete the Main.storyboard file and set the Main interface in app options to empty. */

import UIKit

//class ViewController: UIViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view, typically from a nib.
//        
//        view.backgroundColor = UIColor.red
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//}


/* The simplest way of getting a UICollectionView is to actually use the UIColllectionViewController
  provided by Apple. */
/* Need protocol UICollectionViewDelegateFlowLayout to set size of cells. Need to implement the optional method sizeForItemAt. */
class CustomCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let customCellIdentifier = "customCellIdentifier"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
//        view.backgroundColor = UIColor.red
        /* UIViewController has a view, UICollectionViewController also has that view because it is a subclass of UIViewController,
         but this controller also has a collectionView which is what is being presented inside of the view. collectionView is
         what we are seing instead of view by default. */
//        collectionView?.backgroundColor = UIColor.red
        // To illustrate what the cell is rendering.
        collectionView?.backgroundColor = UIColor.white
        
        collectionView?.register(CustomCell.self, forCellWithReuseIdentifier: customCellIdentifier)
    }
    
    let names = ["Mark Zuckerberg", "Bill Gates", "Steve Jobs"]
    
    /* We need to tell it how many cells to return, using the numberOfItemsInSection method. */
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return names.count
    }
    
    /* We want to tell the UICollectionViewController what type of cell we want to return, with cellForItemAt. Need to
     return a UICollectionViewCell. We need to first register the collection view with a cell to a matching identifier. */
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let customCell = collectionView.dequeueReusableCell(withReuseIdentifier: customCellIdentifier, for: indexPath) as! CustomCell
        customCell.nameLabel.text = names[indexPath.item]
        return customCell
    }
    
    // Setting the size of the cells.
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }
    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
    
}

class CustomCell: UICollectionViewCell {
    
    /* By default cells are 50x50 pixels. */
    
    /* init(frame:) is actually called when collectionView dequeues a cell, which is why we run setupViews() inside it. */
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    /* Just add below initializer so that the compiler does not complain. */
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /* This is relatively new syntax in Swift, where we can declare a block with curly braces, and then we can execute that block
     with the open and close paranthesis, and upon the execution it is going to return a label. */
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Custom text"
        // If you omit this you will get an error / warning, and the constraints do not work.
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func setupViews() {
        
        // To illustrate what the cell is rendering.
        backgroundColor = UIColor.red
        
        addSubview(nameLabel)
        
        // should be addConstraints and not addConstraint. Add the missing s at the end.
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}







