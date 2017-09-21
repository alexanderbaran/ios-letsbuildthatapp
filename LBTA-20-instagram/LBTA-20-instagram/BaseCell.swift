//
//  BaseCell.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 21/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        
    }
}
