//
//  CommentInputAccessoryView.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 19/03/2018.
//  Copyright © 2018 Alexander Baran. All rights reserved.
//

import UIKit

protocol CommentInputAccessoryViewDelegate: class {
    func didSubmit(for comment: String?)
}

class CommentInputAccessoryView: UIView, UITextViewDelegate {
    
    weak var delegate: CommentInputAccessoryViewDelegate?
    
    func clearCommentText() {
        textView.text = nil
        textView.showPlaceholderLabel()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CommentInputAccessoryView deinit")
    }
    
    // https://stackoverflow.com/questions/34980391/entering-text-into-ui-textfield-by-pressing-return-button
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        handleSubmit()
//        guard let text = textField.text else { return true }
        handleSubmit()
        return true
    }
    
    @objc func handleSubmit() {
        delegate?.didSubmit(for: textView.text)
    }
    
//    lazy var textField: UITextField = {
    // UITextView supports multi line.
    lazy var textView: CommentInputTextView = {
        let tv = CommentInputTextView()
//        tv.placeholder = "Enter Comment" // UITextView does not have placeholder property.
        tv.isScrollEnabled = false // Will wordwrap automatically.
//        tv.backgroundColor = .red
        tv.font = UIFont.systemFont(ofSize: 16)
//        tv.delegate = self
        return tv
    }()
    
    private let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.5, alpha: 0.5)
        return view
    }()
    
    lazy var submitButton: UIButton = {
//    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        return button
    }()
    
    // Basically what this is doing is for the intrinsic size of this entire comment accessory view container it is going to just return .zero which tells the OS that you can actually resize it however you want it to resize based on the components inside of it.
    override var intrinsicContentSize: CGSize {
        return .zero
    }
    
    func setupViews() {
        
        // autoresizingMask is the property that you set to kinda tell this entire container how to resize itself if it needs to and if you set this to flexible height it is just going to get taller if it needs to resize to be a little bit taller.
        autoresizingMask = .flexibleHeight

        // Background needs to be white to prevent opaqueness and seethrough.
        backgroundColor = .white
        
        addSubview(textView)
        addSubview(separator)
        addSubview(submitButton)
        
        var osDependentBottomAnchor = bottomAnchor
        if #available(iOS 11.0, *) {
            // For iPhone X
            osDependentBottomAnchor = safeAreaLayoutGuide.bottomAnchor
        }
        textView.anchor(top: topAnchor, left: leftAnchor, bottom: osDependentBottomAnchor, right: submitButton.leftAnchor, topConstant: 8, leftConstant: 12, bottomConstant: -8, rightConstant: 0, widthConstant: 0, heightConstant: 0)
        
        separator.anchor(top: topAnchor, left: leftAnchor, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 0, heightConstant: 0.5)
        
        submitButton.anchor(top: topAnchor, left: nil, bottom: nil, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 50, heightConstant: 50)
//        submitButton.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, topConstant: 0, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 50, heightConstant: 0)

    }
}
