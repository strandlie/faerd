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
    
    static let shared = LocationController()
   
    let locationManager = CLLocationManager()
    
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
    
    func updateNearbyStopsTo(coordinate: CLLocation, limitStops: Int? = nil, radius: Double? = nil) {
        
        APIController.shared.updateNearbyStopsToAPIRequest(coordinate: coordinate, limitStops: limitStops, radius: radius)
    }
    
    static func formattedDistanceBetween(location1: CLLocation?, location2: CLLocation?) -> String {
        guard let location1 = location1, let location2 = location2 else {
            return "-"
        }
        let distance = location1.distance(from: location2).rounded()
        return String(format: "%.0f", distance) + " m"
    }
    
    static func actualDistanceBetween(location1: CLLocation?, location2: CLLocation?) -> Double? {
        guard let location1 = location1, let location2 = location2 else {
            return nil
        }
        return location1.distance(from: location2)
    }
    
    
    /**
     Only the most recent location is relevant to us.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            User.shared.currentLocation = locations.last
            if let currentLocation = User.shared.currentLocation {
                updateNearbyStopsTo(coordinate: currentLocation)
            }
        }
        
        
        
    }
    
}
