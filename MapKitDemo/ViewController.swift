//
//  ViewController.swift
//  MapKitDemo
//
//  Created by Falguni Viral Chauhan on 09/09/18.
//  Copyright © 2018 Falguni Viral Chauhan. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    let regionAreaInMeter: Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkDeviceLevelPermission()
    }

    func centerViewOnUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionAreaInMeter, longitudinalMeters: regionAreaInMeter)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func setupLocationManager() {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func checkDeviceLevelPermission() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkAuthorizationPermission()
        } else {
            let alertVC = UIAlertController(title: "Location", message: "You'r location service is off, please enable to access this app", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertVC.addAction(okAction)
            self.present(alertVC, animated: true, completion: nil)
        }
    }
    
    func checkAuthorizationPermission() {
        switch CLLocationManager.authorizationStatus() {
            case .authorizedWhenInUse:
                mapView.showsUserLocation = true
                locationManager.startUpdatingLocation()
            break
            case .authorizedAlways:
                break
            case .denied:
                break
            case .notDetermined:
                locationManager.requestWhenInUseAuthorization()
            case .restricted:
                break
        }
    }
}


extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionAreaInMeter, longitudinalMeters: regionAreaInMeter)
        mapView.setRegion(region, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAuthorizationPermission()
    }
}

