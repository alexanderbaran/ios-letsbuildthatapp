//
//  Cells.swift
//  LBTA-4-rss-reader
//
//  Created by Alexander Baran on 27/08/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class EntryCell: BaseCell {
    
    let titleLabel: UILabel = {
        let label = UILabel()
//        label.font = UIFont.boldSystemFontOfSize(14)
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let contentSnippetTextView: UITextView = {
        let textView = UITextView()
//        textView.scrollEnabled = false
        // Need to disable scroll to expand content height automatically with preferredLayoutAttributesFitting and layout.estimatedItemSize.
        textView.isScrollEnabled = false
//        textView.userInteractionEnabled = false
        textView.isUserInteractionEnabled = false
        return textView
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        addSubview(titleLabel)
        addSubview(contentSnippetTextView)
        addSubview(dividerView)
        
//        addConstraintsWithFormat("H:|-8-[v0]-8-|", views: titleLabel)
//        addConstraintsWithFormat("H:|-3-[v0]-3-|", views: contentSnippetTextView)
//        addConstraintsWithFormat("H:|-8-[v0]|", views: dividerView)
//        
//        addConstraintsWithFormat("V:|-8-[v0(20)]-8-[v1][v2(0.5)]|", views: titleLabel, contentSnippetTextView, dividerView)
        addConstraintsWithFormat(format: "H:|-8-[v0]-8-|", views: titleLabel)
        addConstraintsWithFormat(format: "H:|-3-[v0]-3-|", views: contentSnippetTextView)
        addConstraintsWithFormat(format: "H:|-8-[v0]|", views: dividerView)
        
        addConstraintsWithFormat(format: "V:|-8-[v0(20)]-8-[v1][v2(0.5)]|", views: titleLabel, contentSnippetTextView, dividerView)
    }
    
//    override func preferredLayoutAttributesFittingAttributes(layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
//        let attr: UICollectionViewLayoutAttributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
//        
//        var newFrame = attr.frame
//        self.frame = newFrame
//        
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        
////        let desiredHeight: CGFloat = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
//        let desiredHeight: CGFloat = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
//        newFrame.size.height = desiredHeight + 20
//        attr.frame = newFrame
//        return attr
        
        /* This method provides us with the ability to set the frame on the window. Also need to set textView.isScrollEnabled = false. */
        
        let attributes = layoutAttributes.copy() as! UICollectionViewLayoutAttributes
        let desiredHeight = systemLayoutSizeFitting(UILayoutFittingCompressedSize).height
        attributes.frame.size.height = desiredHeight
        
        return attributes
    }
}

class SearchHeader: BaseCell, UITextFieldDelegate {
    
    var searchFeedController: SearchFeedController?
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search for RSS Feeds"
//        textField.font = UIFont.systemFontOfSize(14)
        textField.font = UIFont.systemFont(ofSize: 14)
        return textField
    }()
    
    let searchButton: UIButton = {
//        let button = UIButton(type: .System)
        let button = UIButton(type: .system)
//        button.setTitle("Search", forState: .Normal)
        button.setTitle("Search", for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFontOfSize(14)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }()
    
    let dividerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    override func setupViews() {
        super.setupViews()
        
//        searchButton.addTarget(self, action: "search", forControlEvents: .TouchUpInside)
        searchButton.addTarget(self, action: #selector(SearchHeader.search), for: .touchUpInside)
        searchTextField.delegate = self
        
        addSubview(searchTextField)
        addSubview(dividerView)
        addSubview(searchButton)
        
//        addConstraintsWithFormat("H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
//        addConstraintsWithFormat("H:|[v0]|", views: dividerView)
//        
//        addConstraintsWithFormat("V:|[v0]|", views: searchButton)
//        addConstraintsWithFormat("V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
        addConstraintsWithFormat(format: "H:|-8-[v0][v1(80)]|", views: searchTextField, searchButton)
        addConstraintsWithFormat(format: "H:|[v0]|", views: dividerView)
        
        addConstraintsWithFormat(format: "V:|[v0]|", views: searchButton)
        addConstraintsWithFormat(format: "V:|[v0][v1(0.5)]|", views: searchTextField, dividerView)
    }
    
    func search() {
//        searchFeedController?.performSearchForText(searchTextField.text!)
        searchFeedController?.performSearchForText(text: searchTextField.text!)
    }
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        searchFeedController?.performSearchForText(searchTextField.text!)
        searchFeedController?.performSearchForText(text: searchTextField.text!)
        return true
    }
    
}

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

extension UIView {
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String: UIView]()
//        for (index, view) in views.enumerate() {
        for (index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
//        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
