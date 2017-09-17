//
//  VideoLauncher.swift
//  LBTA-15-youtube
//
//  Created by Alexander Baran on 17/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import AVFoundation

class VideoPlayerView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        let urlString = "https://firebasestorage.googleapis.com/v0/b/lbta-16-firebase-chat.appspot.com/o/message_movies%2F5D9EE901-17F3-4B1C-AB86-4C1B2D85E951.mov?alt=media&token=b8f8967b-58ec-4f1b-ac2d-5ea1e10395fa"
        if let url = URL(string: urlString) {
            let player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player.play()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
//        print("Showing video player animation....")
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let view = UIView(frame: window.frame)
        view.backgroundColor = .white
        
        view.frame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
        
        // 16:9 is the aspect ratio of all HD videos.
        let height = 9 / 16 * window.frame.width
        let videoPlayerFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        let videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
        view.addSubview(videoPlayerView)
        
        window.addSubview(view)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { 
                view.frame = window.frame
        }) { (completed: Bool) in
            // Hide the status bar.
            UIApplication.shared.isStatusBarHidden = true
            // Deprecated
//            UIApplication.shared.setStatusBarHidden(true, with: .fade)
            // https://stackoverflow.com/questions/32808593/setstatusbarhidden-withanimation-deprecated-in-ios-9
        }

    }
    
}
