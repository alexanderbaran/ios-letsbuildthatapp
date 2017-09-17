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
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView()
        activityView.activityIndicatorViewStyle = .whiteLarge
        activityView.startAnimating()
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    
    private let pauseImage = UIImage(named: "pause")
    private let playImage = UIImage(named: "play")
    
    lazy var pausePlayButton: UIButton = {
        let button = UIButton(type: .system)
        // This is a closure so need self in font of pauseImage
        button.setImage(self.pauseImage, for: .normal)
        button.tintColor = .white
        button.isHidden = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        return button
    }()
    
    private var isPlaying: Bool = true
    
    func handlePause() {
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(playImage, for: .normal)
        } else {
            player?.play()
            pausePlayButton.setImage(pauseImage, for: .normal)
        }
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    let videoLengthLabel: UILabel = {
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .right
        return label
    }()
    
    let currentTimeLabel: UILabel = {
        let label = UILabel();
        label.text = "00:00"
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .left
        return label
    }()
    
    lazy var videoSlider: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
//        slider.thumbTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "thumb"), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.addTarget(self, action: #selector(handleSliderSlider), for: .valueChanged)
        return slider
    }()
    
    func handleSliderSlider() {
        if let duration = player?.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let value = Float64(videoSlider.value) * totalSeconds
            // If timescale is set to one then value becomes seconds.
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            player?.seek(to: seekTime, completionHandler: { (completed: Bool) in
                
            })
        }

//        print(videoSlider.value)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        setupPlayerView()
        setupGradientLayer()
        
        // This has to come after player so that the controls are above the video.
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(videoLengthLabel)
        videoLengthLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        videoLengthLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(currentTimeLabel)
        currentTimeLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimeLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        currentTimeLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimeLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.leftAnchor.constraint(equalTo: currentTimeLabel.rightAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.rightAnchor.constraint(equalTo: videoLengthLabel.leftAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var player: AVPlayer?
    
    private func setupPlayerView() {
        let urlString = "https://firebasestorage.googleapis.com/v0/b/lbta-16-firebase-chat.appspot.com/o/message_movies%2F5D9EE901-17F3-4B1C-AB86-4C1B2D85E951.mov?alt=media&token=b8f8967b-58ec-4f1b-ac2d-5ea1e10395fa"
        if let url = URL(string: urlString) {
            player = AVPlayer(url: url)
            // Tryint to figure out when a video has started playing. Whenever we add this observer on to an object like that, we have to implement this method called observeValueForKeyPath.
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            
            
            // Track player progress.
            let interval = CMTime(value: 1, timescale: 2) // Interval of 0.5 second.
//            let interval = CMTime(value: 1, timescale: 1) // Interval of 1 second.
            player?.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.main, using: { (progressTime: CMTime) in
                let atSeconds = CMTimeGetSeconds(progressTime)
//                print(totalSeconds)
                let secondsText = String(format: "%02d", Int(atSeconds) % 60)
                let minutesText = String(format: "%02d", Int(atSeconds) / 60)
                self.currentTimeLabel.text = "\(minutesText):\(secondsText)"
                
                if let duration = self.player?.currentItem?.duration {
                    let totalSeconds = CMTimeGetSeconds(duration)
                    let value = atSeconds / totalSeconds
                    self.videoSlider.setValue(Float(value), animated: true)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // This is when the player is ready and rendering frames.
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            // To compensate because the loader stops a little while after the video has started playing.
            controlsContainerView.backgroundColor = .clear
            pausePlayButton.isHidden = false
            
            if let duration = player?.currentItem?.duration {
                let totalSeconds = CMTimeGetSeconds(duration)
                let secondsText = String(format: "%02d", Int(totalSeconds) % 60)
                let minutesText = String(format: "%02d", Int(totalSeconds) / 60)
                videoLengthLabel.text = "\(minutesText):\(secondsText)"
            }
        }
    }
    
    private func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        // You can think of 0 at the very top, 1 at the bottom, and 1.2 below the bottom, that the gradient actually starts from below the video.
        gradientLayer.locations = [0.7, 1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
}

class VideoLauncher: NSObject {
    
    func showVideoPlayer() {
//        print("Showing video player animation....")
        guard let window = UIApplication.shared.keyWindow else {
            return
        }
        let startingFrame = CGRect(x: window.frame.width - 10, y: window.frame.height - 10, width: 10, height: 10)
        let view = UIView(frame: startingFrame)
        view.backgroundColor = .white
        
        // 16:9 is the aspect ratio of all HD videos.
        let height = 9 / 16 * window.frame.width
        let endingFrame = CGRect(x: 0, y: 0, width: window.frame.width, height: height)
        let videoPlayerView = VideoPlayerView(frame: endingFrame)
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
