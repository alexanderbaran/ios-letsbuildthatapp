//
//  BaseCell.swift
//  LBTA-17-audible
//
//  Created by Alexander Baran on 17/09/2017.
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
