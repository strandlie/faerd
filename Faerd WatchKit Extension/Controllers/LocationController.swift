//
//  LocationController.swift
//  Ferd WatchKit Extension
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
                AppState.shared.hasLocationAccess = false
                break
            
            case .authorizedWhenInUse, .authorizedAlways:
                AppState.shared.hasLocationAccess = true
                locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                locationManager.startUpdatingLocation()
                break
            @unknown default:
                fatalError()
        }
        
        
    }
    
    func updateNearbyStopsTo(coordinate: CLLocation) {
        APIController.shared.updateNearbyStopsToAPIRequest(coordinate: coordinate)
    }
    
    static func formattedDistanceBetween(location1: CLLocation?, location2: CLLocation?) -> String {
        guard let location1 = location1, let location2 = location2 else {
            return "-"
        }
        let distance = location1.distance(from: location2).rounded()
        if distance > 999 {
            return String(format: "%.0f", distance / 1000) + " km"
        }
        return String(format: "%.0f", distance) + " m"
    }
    
    static func actualDistanceBetween(location1: CLLocation?, location2: CLLocation?) -> Double? {
        guard let location1 = location1, let location2 = location2 else {
            return nil
        }
        return location1.distance(from: location2)
    }
    
    func updateStopsNearUser() {
        if let currentLocation = User.shared.currentLocation {
            self.updateNearbyStopsTo(coordinate: currentLocation)
        }
    }
    
    
    /**
     Only the most recent location is relevant to us.
     */
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if locations.count > 0 {
            User.shared.currentLocation = locations.last
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            AppState.shared.hasLocationAccess = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        switch(status) {
        case .authorizedAlways, .authorizedWhenInUse:
            AppState.shared.hasLocationAccess = true
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        case .denied, .notDetermined, .restricted:
            BusStopList.shared.removeAll()
        @unknown default:
            fatalError("Unexpected location status: \(status)")
        }
    }
    
}
