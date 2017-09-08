//
//  ViewController.swift
//  LBTA-4-rss-reader
//
//  Created by Alexander Baran on 27/08/17.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

class SearchFeedController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var entries: [Entry]? = [
        Entry(title: "Sample Title 1", contentSnippet: "Sample Content Snippet 1", url: nil),
        Entry(title: "Sample Title 2", contentSnippet: "Sample Content Snippet 2", url: nil),
        Entry(title: "Sample Title 3", contentSnippet: "Sample Content Snippet 3", url: nil)
    ]
    
    let entryCellId = "entryCellId"
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "RSS Reader"
        
//        collectionView?.registerClass(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
//        collectionView?.registerClass(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.register(EntryCell.self, forCellWithReuseIdentifier: entryCellId)
        collectionView?.register(SearchHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView?.backgroundColor = UIColor.white
        collectionView?.alwaysBounceVertical = true
        
        if let layout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
//            layout.minimumLineSpacing = 0
//            layout.headerReferenceSize = CGSizeMake(view.frame.width, 50)
//            layout.headerReferenceSize = CGSize(width: view.frame.width, height: 50)
            // This could not be in AppDelegate.swift for some reason. 
            layout.estimatedItemSize = CGSize(width: view.frame.width, height: 100)
        }
    }
    
    func performSearchForText(text: String) {
//        print("Performing search for \(text), please wait...")
        
        // text string can have spaces, to prevent crash need to add addingPercentEncoding.
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
//        print(encodedText)
        let urlString = "https://api.rss2json.com/v1/api.json?rss_url=https%3A%2F%2Fhnrss.org%2Fnewest%3Fq%3D\(encodedText)"
//        let url = NSURL(string: urlString)
        let url = URL(string: urlString)
        
        var urlRequest = URLRequest(url: url!)
        urlRequest.httpMethod = "GET"
        
//        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
        let task = URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            
//            let string = String(data: data!, encoding: String.Encoding.utf8)
//            print(string!)
            
            do {
                /* The only (rare) option which is useful in Swift is .allowFragments which is required if if the JSON
                 root object could be a value type(String, Number, Bool or null) rather than one of the collection
                 types (array or dictionary). But normally omit the options parameter which means No options.
                 https://stackoverflow.com/questions/39423367/correctly-parsing-json-in-swift-3
                 https://developer.apple.com/swift/blog/?id=37 */
                let jsonObject = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions())
                
                // https://medium.com/@mimicatcodes/unwrapping-optional-values-in-swift-3-0-guard-let-vs-if-let-40a0b05f9e69
                // Can't use if let here because it is not available in outside of the brackets.
                guard let dictionary = jsonObject as? NSDictionary else {
                    print("SearchFeedController performSearchForText() Not a Dictionary")
                    return
                }
                
//                let items = dictionary["items"] as? NSArray
//                let items = dictionary["items"] as? Array<Any>
                // By casting to array of NSDictionary we don't have to cast to arrat first then dictionary later.
                guard let items = dictionary["items"] as? [NSDictionary] else {
                    print("SearchFeedController performSearchForText() Not an Array")
                    return
                }
                
////                let item1 = items[0] as? NSDictionary
//                guard let item1 = items[0] as? Dictionary<String, Any> else {
//                    print("Not a Dictionary")
//                    return
//                }
//                
////                let title = item1["title"] as? String
//                guard let title = item1["title"] as? String else {
//                    print("Not a String")
//                    return
//                }
//                
//                print(title)
                
                // Need self keyword here because of inside closure.
                self.entries = [Entry]()
                for item in items {
                    guard let title = item["title"] as? String else {
                        print("SearchFeedController performSearchForText() title not a String")
                        return
                    }
                    guard let content = item["content"] as? String else {
                        print("SearchFeedController performSearchForText() content not a String")
                        return
                    }
                    guard let link = item["link"] as? String else {
                        print("SearchFeedController performSearchForText() link not a String")
                        return
                    }
                    // https://stackoverflow.com/questions/28957940/remove-all-line-breaks-at-the-beginning-of-a-string-in-swift
                    let trimmedContent = content.replacingOccurrences(of: "^\\s*", with: "", options: .regularExpression)
                    self.entries?.append(Entry(title: title, contentSnippet: trimmedContent, url: link))
                }
                
                // https://stackoverflow.com/questions/37805885/how-to-create-dispatch-queue-in-swift-3
                /* You are in a background thread, you need to get back to the main UI thread to execute a UI change. */
                DispatchQueue.main.async(execute: { 
                    self.collectionView?.reloadData()
                })
                
                
            } catch let error {
                print(error)
            }
            
            
        }
        
        task.resume()
    }
    
//    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = entries?.count {
            return count
        }
        return 0
    }
    
    
////    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: IndexPath) -> UICollectionViewCell {
////        let entryCell = collectionView.dequeueReusableCellWithReuseIdentifier(entryCellId, forIndexPath: indexPath) as! EntryCell
//        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
//        let entry = entries?[indexPath.item]
//        entryCell.titleLabel.text = entry?.title
//        entryCell.contentSnippetTextView.text = entry?.contentSnippet
//        return entryCell
//    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let entryCell = collectionView.dequeueReusableCell(withReuseIdentifier: entryCellId, for: indexPath) as! EntryCell
        let entry = entries?[indexPath.item]
        entryCell.titleLabel.text = entry?.title
        
        let data = entry?.contentSnippet?.data(using: String.Encoding.unicode)
        let options = [NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType]
        do {
            let htmlText = try NSAttributedString(data: data!, options: options, documentAttributes: nil)
            entryCell.contentSnippetTextView.attributedText = htmlText
        } catch let error {
            print(error)
        }
        
        return entryCell
    }
    

//    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: headerId, forIndexPath: indexPath) as! SearchHeader
//        header.searchFeedController = self
//        return header
//    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! SearchHeader
        header.searchFeedController = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
////        return CGSizeMake(view.frame.width, 80)
//        return CGSize(width: view.frame.width, height: 80)
//    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let controller = FeedDetailController(collectionViewLayout: UICollectionViewFlowLayout())
        controller.content = entries?[indexPath.item].contentSnippet
        navigationController?.pushViewController(controller, animated: true)
        navigationController?.navigationBar.tintColor = UIColor.white
    }
}

struct Entry {
    var title: String?
    var contentSnippet: String?
    var url: String?
}
