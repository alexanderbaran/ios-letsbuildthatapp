//
//  ViewController.swift
//  LBTA-11-google-maps-sdk
//
//  Created by Alexander Baran on 09/09/2017.
//  Copyright © 2017 Alexander Baran. All rights reserved.
//

import UIKit
import GoogleMaps

/* When we subclass it as NSObject we get access to some methods that are sometimes nice to have. We need to do this whenever instances of
 that type need to behave like an Objective-C object. */
class VacationDestination: NSObject {
    let name: String
    let location: CLLocationCoordinate2D
    let zoom: Float
    
    init(name: String, location: CLLocationCoordinate2D, zoom: Float) {
        self.name = name
        self.location = location
        self.zoom = zoom
    }
}

class ViewController: UIViewController {
    
    // Need a reference to the map view.
    var mapView: GMSMapView?
    
    var currentDestination: VacationDestination?
    
    var destinations = [
        VacationDestination(name: "Embarcadero Station", location: CLLocationCoordinate2D(latitude: 37.792899, longitude: -122.397093), zoom: 15),
        VacationDestination(name: "Ferry Building", location: CLLocationCoordinate2D(latitude: 37.795501, longitude: -122.393544), zoom: 18)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSServices.provideAPIKey("AIzaSyBiuRoK-8UabI7yqszbg6bmM4mJjil40qI")
        
        // You can play around with the zoom level to get a feel of how it works.
        let camera = GMSCameraPosition.camera(withLatitude: 37.621262, longitude: -122.378945, zoom: 12)
        mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let currentLocation = CLLocationCoordinate2D(latitude: 37.621262, longitude: -122.378945)
        let marker = GMSMarker(position: currentLocation)
        marker.title = "SFO Airport"
        // To place it on the map.
        marker.map = mapView
        
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(ViewController.toNextLocation))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Next", style: .plain, target: self, action: #selector(toNextLocation))
    }
    
    func toNextLocation() {
        
        if currentDestination == nil {
            currentDestination = destinations.first
        } else {
            if let index = destinations.index(of: currentDestination!) {
                currentDestination = destinations[index + 1]
            }
        }
        
        setMapCamera()
    }
    
    private func setMapCamera() {
        // This affects animation duration of Google Maps.
        CATransaction.begin()
        CATransaction.setValue(2, forKey: kCATransactionAnimationDuration)
        mapView?.animate(to: GMSCameraPosition.camera(withTarget: currentDestination!.location, zoom: currentDestination!.zoom))
        CATransaction.commit()
        
        let marker = GMSMarker(position: currentDestination!.location)
        marker.title = currentDestination!.name
        // To place it on the map.
        marker.map = mapView
    }

}

