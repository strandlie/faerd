//
//  BusStop.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 20/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import SwiftUI
import CoreLocation

struct BusStop: Identifiable, Decodable {
    
    let id: String
    let name: String // Name of BusStop
    let location: CLLocation
    let departures: DepartureList
    
    enum CodingKeys: String, CodingKey {
        case longitude = "point.lon"
        case latitude = "point.lat"
        case identification = "id"
        case name = "name"
    }
    
    enum Direction: String {
        case towardsCity = "Inn mot byen"
        case fromCity = "Ut fra byen"
        case undefined = ""
    }
    
    /**
        Initializer with lat/long as Floats
     */
    init(id: String, name: String, longitude: Float, latitude: Float) {
        self.id = id
        self.name = name
        self.location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.departures = DepartureList()
        
        self.updateRealtimeDepartures()
        
    }
    
    /**
        Initializer with CLLocation
     */
    init(id: String, name: String, location: CLLocation) {
        self.id = id
        self.name = name
        self.location = location
        self.departures = DepartureList()
        
        self.updateRealtimeDepartures()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        let id = try container.decode(String.self, forKey: .identification)
        let name = try container.decode(String.self, forKey: .name)
        
        let longitude = try container.decode(Float.self, forKey: .longitude)
        let latitude = try container.decode(Float.self, forKey: . latitude)
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))

        
        self.init(id: id, name: name, location: location)
        
    }
    
    func updateRealtimeDepartures() {
        APIController.shared.getRealtimeDeparturesForAPIRequest(busStop: self)
    }

}

