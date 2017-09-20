//
//  ViewController.swift
//  LBTA-19-magical-grid
//
//  Created by Alexander Baran on 20/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit

//extension CGFloat {
//    static func random() -> CGFloat {
//        return CGFloat(arc4random()) / CGFloat(UInt32.max)
//    }
//}
//
//extension UIColor {
//    static func random() -> UIColor {
//        return UIColor(red: .random(), green: .random(), blue: .random(), alpha: 1.0)
//    }
//}

class ViewController: UIViewController {

    private func randomColor() -> UIColor {
        let red = CGFloat(drand48()) // Random double from zero to 1.
        let green = CGFloat(drand48())
        let blue = CGFloat(drand48())
        return UIColor(red: red, green: green, blue: blue, alpha: 1)
    }
    
//    var currentCellView: UIView?
//    var currentCellViewFrame: CGRect?

    var selectedCell: UIView?
    
    func handlePan(gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: view)
//        print(location)

        let width = view.frame.width / CGFloat(numViewPerRow)
        let i = Int(location.x / width)
        let j = Int(location.y / width)
        
        let key = "\(i)|\(j)"
        guard let cellView = cells[key] else { return }
//        cellView?.backgroundColor = .black
        
        if selectedCell != cellView {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: nil)
        }
        
        selectedCell = cellView
        
        view.bringSubview(toFront: cellView)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
//            cellView?.backgroundColor = .black
            cellView.layer.transform = CATransform3DMakeScale(3, 3, 3)
        }, completion: nil)
        
        if gesture.state == .ended {
            UIView.animate(withDuration: 0.5, delay: 0.25, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.selectedCell?.layer.transform = CATransform3DIdentity
            }, completion: { (_) in
            })
        }
        
//        if currentCellView != cellView {
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
//                self.currentCellView?.frame = self.currentCellViewFrame!
//            }, completion: nil)
//            currentCellView = cellView
//            currentCellViewFrame = cellView?.frame
//            cellView?.removeFromSuperview()
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
//                cellView?.frame = CGRect(x: (CGFloat(i) * width) - (width/2), y: (CGFloat(j) * width) - (width/2), width: width * 2, height: width * 2)
//            }, completion: nil)
//            view.addSubview(cellView!)
//        }

        
//        var loopCount = 0
//        for subView in view.subviews {
////            subView.backgroundColor = .black
//            if subView.frame.contains(location) {
//                subView.backgroundColor = .black
//                print(loopCount)
//            }
//            loopCount += 1
//        }
    }
    
    let numViewPerRow = 15
    
    var cells = [String: UIView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = view.frame.width / CGFloat(numViewPerRow)
        
        let numViewPerColumn = Int(view.frame.height / CGFloat(width))
        
        for j in 0..<numViewPerColumn {
            for i in 0..<numViewPerRow {
                let cellView = UIView()
                cellView.backgroundColor = randomColor()
                cellView.layer.borderWidth = 0.5
                cellView.layer.borderColor = UIColor.black.cgColor
                cellView.frame = CGRect(x: CGFloat(i) * width, y: CGFloat(j) * width, width: width, height: width)
                view.addSubview(cellView)
                let key = "\(i)|\(j)"
                cells[key] = cellView
            }
        }
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))


//        let amountX = 10
//        
//        let size: CGFloat = view.frame.width / CGFloat(amountX)
////        let amountX = Int(Int(view.frame.width / size))
//        
//        let amountY = Int(view.frame.height / size)
//        
//        for i in 0..<amountX {
//            for j in 0..<amountY {
//                let squareView = UIView()
//                squareView.backgroundColor = UIColor.random()
//                let x: CGFloat = CGFloat(i) * size
//                let y: CGFloat = CGFloat(j) * size
//                squareView.frame = CGRect(x: x, y: y, width: size, height: size)
//                squareView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(zoomSquare)))
//                view.addSubview(squareView)
//            }
//        }
//
//        let redView = UIView()
//        redView.backgroundColor = .red
//        redView.frame = CGRect(x: 0, y: 0, width: 10, height: 10)
//        
//        view.addSubview(redView)
    }
    
//    func zoomSquare(sender: UIPanGestureRecognizer) {
//        print(sender)
//        print("zooming")
//    }

}

