//
//  APIController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire

class APIController: NSObject  {
    let GLOBAL_MAX_STOPS = 30
    let SEARCH_RADIUS = 350.0
    
    let API_ENDPOINT = "https://rp.atb.no/scripts/TravelMagic/TravelMagicWE.dll/mapjson"
    
    override init() {
        
    }
    
    func getNearbyStopsToAPIRequest(coordinate: CLLocation, limitStops: Int? = nil, radius: Double? = nil) throws -> [BusStop] {
        let eastLimit = locationWithBearing(bearing: 45, distanceMeters: radius ?? SEARCH_RADIUS, origin: coordinate.coordinate)
        let westLimit = locationWithBearing(bearing: 225, distanceMeters: radius ?? SEARCH_RADIUS, origin: coordinate.coordinate)
        
        let parameters: Parameters = [
            "x1": min(eastLimit.longitude, westLimit.longitude),
            "y1": min(eastLimit.latitude, westLimit.latitude),
            "x2": max(eastLimit.longitude, westLimit.longitude),
            "y2": max(eastLimit.latitude, westLimit.latitude)
        ]
        
        
        AF.request(API_ENDPOINT, parameters: parameters).responseJSON { response in
            print("Got response: \(response.result)")
            
        }
        
        // Sort based on distance
        // Return only limitStops amount
        
        return []
        
    }
    
    
    
    func locationWithBearing(bearing:Double, distanceMeters:Double, origin:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let distRadians = distanceMeters / (6372797.6)
        
        let rbearing = bearing * Double.pi / 180.0
        
        let lat1 = origin.latitude * Double.pi / 180
        let lon1 = origin.longitude * Double.pi / 180
        
        let lat2 = asin(sin(lat1) * cos(distRadians) + cos(lat1) * sin(distRadians) * cos(rbearing))
        let lon2 = lon1 + atan2(sin(rbearing) * sin(distRadians) * cos(lat1), cos(distRadians) - sin(lat1) * sin(lat2))
        
        return CLLocationCoordinate2D(latitude: lat2 * 180 / Double.pi, longitude: lon2 * 180 / Double.pi)
    }
    
}
