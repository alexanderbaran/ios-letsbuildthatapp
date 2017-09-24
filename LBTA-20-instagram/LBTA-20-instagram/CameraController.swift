//
//  CameraController.swift
//  LBTA-20-instagram
//
//  Created by Alexander Baran on 23/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import AVFoundation

class CameraController: UIViewController, AVCapturePhotoCaptureDelegate, UIViewControllerTransitioningDelegate {
    
    let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "right_arrow_shadow")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    func handleDismiss() {
        dismiss(animated: true, completion: nil)
    }
    
    let capturePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(named: "capture_photo")?.withRenderingMode(.alwaysOriginal)
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(handleCapturePhoto), for: .touchUpInside)
        return button
    }()
    
    // https://stackoverflow.com/questions/46227230/weird-compile-error-with-avcapture-after-updating-to-xcode-9-swift-4
    @objc func handleCapturePhoto() {
        // Processes the captured photo.
        let settings = AVCapturePhotoSettings()
        // Doesn't show in the simulator.
        #if (!arch(x86_64))
            // https://stackoverflow.com/questions/46202060/apple-mach-o-linker-ld-error-group-with-swift-3-xcode-9-gm/46202917#46202917
            guard let previewFormatType = settings.__availablePreviewPhotoPixelFormatTypes.first else { return }
            settings.previewPhotoFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewFormatType]
            output.capturePhoto(with: settings, delegate: self)
        #endif
    }
    
    func capture(_ output: AVCapturePhotoOutput, didFinishProcessingPhotoSampleBuffer photoSampleBuffer: CMSampleBuffer?, previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer!, previewPhotoSampleBuffer: previewPhotoSampleBuffer!)
        let previewImage = UIImage(data: imageData!)
        
        let containerView = PreviewPhotoContainerView()
        containerView.previewImageView.image = previewImage
        view.addSubview(containerView)
        containerView.fillSuperview()
        
//        let previewImageView = UIImageView(image: previewImage)
//        view.addSubview(previewImageView)
//        previewImageView.fillSuperview()
//        
//        print("Finished processing photo sample buffer.. ")
    }
    
    let output = AVCapturePhotoOutput()
    
    private func setupCaptureSession() {
        let captureSession = AVCaptureSession()
        // 1. Setup inputs.
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        do {
            let input = try AVCaptureDeviceInput(device: captureDevice)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
        } catch let error {
            print("Could not setup camera input:", error)
        }
        // 2. Setup outputs.
        //        let output = AVCapturePhotoOutput()
        
        if captureSession.canAddOutput(output) {
            captureSession.addOutput(output)
        }
        // 3. Setup output preview.
        guard let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) else { return }
        previewLayer.frame = view.frame
        view.layer.addSublayer(previewLayer)
        captureSession.startRunning()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Doing this for custom transitioning between views.
        transitioningDelegate = self
        
        setupCaptureSession()
        
        // HUD: head-up display
        // https://en.wikipedia.org/wiki/Head-up_display
        setupHUD()
    }
    
    let customAnimationPresentor = CustomAnimationPresentor()
    let customAnimationDismisser = CustomAnimationDismisser()
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationPresentor
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return customAnimationDismisser
    }
    
    private func setupHUD() {
        view.addSubview(capturePhotoButton)
        view.addSubview(dismissButton)
        
        // Bring the photo in assets to 1x from 2x to make it bigger. The 1x sizing is bigger.
        capturePhotoButton.anchor(top: nil, left: nil, bottom: view.bottomAnchor, right: nil, topConstant: 0, leftConstant: 0, bottomConstant: -24, rightConstant: 0, widthConstant: 80, heightConstant: 80)
        capturePhotoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        dismissButton.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, topConstant: 12, leftConstant: 0, bottomConstant: 0, rightConstant: -12, widthConstant: 50, heightConstant: 50)
    }
    
    
}




















