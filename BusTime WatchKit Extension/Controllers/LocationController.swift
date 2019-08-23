//
//  LocationController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 23/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation

class LocationController: NSObject, CLLocationManagerDelegate {
   
    let locationManager = CLLocationManager()
    let apiController = APIController()
    
    static let shared = LocationController()
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
            case .notDetermined:
                // Request when-in-use authorization initially
                locationManager.requestWhenInUseAuthorization()
                break
            
            case .restricted, .denied:
                // Disable location features
                break
            
            case .authorizedWhenInUse, .authorizedAlways:
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                break
            @unknown default:
                fatalError()
        }
    }
    
    func getNearbyStopsTo(coordinate: CLLocation, limitStops: Int? = nil, radius: Double? = nil) -> [BusStop] {
        return apiController.getNearbyStopsToAPIRequest(coordinate: coordinate, limitStops: limitStops, radius: radius)
    }
    
    static func formattedDistanceBetween(location1: CLLocation?, location2: CLLocation?) -> String {
        guard let location1 = location1, let location2 = location2 else {
            return "-"
        }
        let distance = location1.distance(from: location2).rounded()
        return String(format: "%.0f", distance) + " m"
    }
    
    
    /**
     Only the most recent location is relevant to us.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //print("Got new location: \(locations)")
        User.shared.currentLocation = locations.last
        if let currentUserLocation = User.shared.currentLocation {
            BusStopList.shared.setNearbyStops(getNearbyStopsTo(coordinate: currentUserLocation))
        }
        
    }
    
}
