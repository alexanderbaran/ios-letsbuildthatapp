//
//  FeedDetailController.swift
//  LBTA-4-rss-reader
//
//  Created by Alexander Baran on 04/09/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"

class FeedDetailController: UICollectionViewController {

//    var entryUrl: String? {
//        didSet {
//            fetchFeed()
//        }
//    }
    
    var content: String? {
        didSet {
            fetchFeed()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.white

        // Register cell classes
        self.collectionView!.register(EntryCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    func fetchFeed() {
        
    }


    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

}
