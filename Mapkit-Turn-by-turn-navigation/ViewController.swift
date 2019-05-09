//
//  ViewController.swift
//  Mapkit-Turn-by-turn-navigation
//
//  Created by Victor Lee on 9/5/19.
//  Copyright © 2019 VictorLee. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var directionsLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    
    let locationManager = CLLocationManager()
    
    //MARK: - Step three Store User Coordinates
    var currentCoordinates: CLLocationCoordinate2D!
    
    fileprivate func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Step one setup
        setupLocationManager()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //MARK: - Step two get user's current location
        manager.startUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        //MARK: - Step four set current coordinate
        currentCoordinates = currentLocation.coordinate
        //MARK: - Step five set heading to track user direction
        mapView.userTrackingMode = .followWithHeading
        
        
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("")
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        return MKOverlayRenderer()
    }
}

