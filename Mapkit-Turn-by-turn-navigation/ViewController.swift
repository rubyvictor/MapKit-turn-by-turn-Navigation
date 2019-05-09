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
    var steps = [MKRoute.Step]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - Step one setup
        setupLocationManager()
    }
    
    fileprivate func setupLocationManager() {
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.startUpdatingLocation()
    }
    
    func getDirections(to destination: MKMapItem) {
        //MARK: - Step ten Initialize placemark of current coordinates and initialize mapItem with it
        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinates)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let directionRequest = MKDirections.Request()
        //MARK: - Step eleven set up direction for source and destination
        directionRequest.source = sourceMapItem
        directionRequest.destination = destination
        //MARK: - Step twelve set up transport type
        directionRequest.transportType = .automobile
        
        //MARK: - Step thirteen Initialize directions
        let directions = MKDirections(request: directionRequest)
        directions.calculate { [weak self] (response, error) in
            if let error = error {
                return
            }
            
            guard let response = response else { return }
            guard let mainRoute = response.routes.first else { return }
            
            
            //MARk: - Step fourteen Add polyline overlay to mapView
            self?.mapView.addOverlay(mainRoute.polyline)
            //MARK: - Step fifteen Save the steps to an empty array
            self?.steps = mainRoute.steps
            
            
            
        }
        
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
        //MARK: - Step six create search request
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        //MARK: - Step seven set up region with span
        let region = MKCoordinateRegion(center: currentCoordinates, span: MKCoordinateSpan.init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        //MARK: - Step eight start local search
        localSearch.start { [weak self] (response, error) in
            if let error = error {
                return
            }
            //MARK: - Step nine get the map items from search response
            guard let response = response else { return }
            print(response.mapItems)
            guard let firstMapItem = response.mapItems.first else { return }
            self?.getDirections(to: firstMapItem)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        //MARK: - step sixteen create renderer for polyline overlay
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .blue
            renderer.lineWidth = 10
            return renderer
        }
        
        return MKOverlayRenderer()
    }
}

