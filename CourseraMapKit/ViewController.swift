//
//  ViewController.swift
//  CourseraMapKit
//
//  Created by Gael Perez on 9/17/17.
//  Copyright © 2017 Coursera. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController,CLLocationManagerDelegate{

    @IBAction func changeType(_ sender: Any) {
        switch mapType.selectedSegmentIndex {
        case 0:
            map.mapType = .hybrid
        case 1:
            map.mapType = .satellite
        default:
            map.mapType = .standard
        }
    }
    
    @IBOutlet weak var mapType: UISegmentedControl!
    @IBOutlet weak var map: MKMapView!
    var locationManager = CLLocationManager()
    var distance = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        map.showsUserLocation = true
        
        requestLocationAccess()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 50
        locationManager.delegate = self
        
        DispatchQueue.main.async {
            locationManager.startUpdatingLocation()
        }
        
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations.last!
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
        var region = MKCoordinateRegionMakeWithDistance(center, 300, 300)
        region.center = map.userLocation.coordinate
        map.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = center
        annotation.title = "Lat: \(center.latitude) - Long: \(center.longitude)"
        annotation.subtitle = "Distance: \(distance)"
        distance += 50
        
        map.addAnnotation(annotation)
    }
    
    
    func requestLocationAccess() {
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }

    
    

}

