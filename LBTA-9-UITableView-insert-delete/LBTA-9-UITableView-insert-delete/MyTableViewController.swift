//
//  ViewController.swift
//  LBTA-9-UITableView-insert-delete
//
//  Created by Alexander Baran on 08/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

let cellId = "cellId"
let headerId = "headerId"

class MyTableViewController: UITableViewController {
    
    var items = ["Item 1", "Item 2", "Item 3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "My TableView"
        
        tableView.register(MyCell.self, forCellReuseIdentifier: cellId)
        tableView.register(Header.self, forHeaderFooterViewReuseIdentifier: headerId)
        
        // Need to specify a size for the header or else it won't even show up.
        tableView.sectionHeaderHeight = 50
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Insert", style: .plain, target: self, action: #selector(MyTableViewController.insert))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Batch Insert", style: .plain, target: self, action: #selector(MyTableViewController.insertBatch))
    }
    
    func insertBatch() {
        /* We can do a couple of things inside of insertBatch. For example we can iterate through some kind of loop, everytime we add a new item we call 
         insertRows(at:with:). But that is not the most efficient way of doing so because it is going to require tableView to render itself multiple times. */
        
        var indexPaths = [IndexPath]()
        for i in items.count...items.count + 5 {
            items.append("Item \(i + 1)")
            indexPaths.append(IndexPath(row: i, section: 0))
        }
        
        var bottomHalfIndexPaths = [IndexPath]()
        for _ in 0...indexPaths.count / 2 - 1 {
            bottomHalfIndexPaths.append(indexPaths.removeLast())
        }
        
        // tableView executes all the animations simultenously.
        tableView.beginUpdates()
        tableView.insertRows(at: indexPaths, with: .right)
        tableView.insertRows(at: bottomHalfIndexPaths, with: .left)
        tableView.endUpdates()
    }
    
    func insert() {
        items.append("Item \(items.count + 1)")
        
        // Section will be 0 because we have only 1 section.
        let insertionIndexPath = IndexPath(row: items.count - 1, section: 0)
        
        // Can also add by using this method. This will also animate.
        tableView.insertRows(at: [insertionIndexPath], with: .automatic)
        
        // Easiest to insert by updating the datasource and calling reloadData(). But it won't animate.
//        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! MyCell
        cell.nameLabel.text = items[indexPath.row]
        cell.myTableViewController = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerId) as! Header
        return header
    }
    
    func deleteCell(cell: UITableViewCell) {
        if let deletetionIndexPath = tableView.indexPath(for: cell) {
            // Must remove from the datasource first before removing the cell.
            // indexPath.row and indexPath.item are indentical.
            items.remove(at: deletetionIndexPath.item)
            // We delete the cell by finding the indexPath of the cell.
            tableView.deleteRows(at: [deletetionIndexPath], with: .automatic)
        }
    }

}

class Header: UITableViewHeaderFooterView {
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "My header"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
    }
}

class MyCell: UITableViewCell {
    
    var myTableViewController: MyTableViewController?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Sample Item"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Delete", for: .normal)
        button.setTitleColor(UIColor.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setupViews() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(MyCell.handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    func handleAction() {
        myTableViewController?.deleteCell(cell: self)
    }
}

