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

/*
 Icons by: https://www.flaticon.com/free-icon
 Attribution required
 */
struct BusStop: Identifiable, Decodable {
    
    let id: String
    let name: String // Name of BusStop
    let location: CLLocation
    let types: [StopType]
    let departures: DepartureList
    
    /*
     Enum for names returned by API
     */
    enum CodingKeys: String, CodingKey {
        case longitude = "point.lon"
        case latitude = "point.lat"
        case identification = "id"
        case name = "name"
        case type = "category"
        case busStop = "onstreetBus"
        case busStation = "busStation"
        case railStation = "railStation"
        case tramStop = "onstreetTram"
        case metroStation = "metroStation"
        case ferryStop = "ferryStop"
        case airport = "airport"
       
    }
    
    /**
        Enum for icon image names
     */
    enum StopType: String {
        case bus = "Bus"
        case train = "Train"
        case tram = "Tram"
        case metro = "Metro"
        case ferry = "Ferry"
        case airport = "Plane"
    }
    
    enum Direction: String {
        case towardsCity = "Inn mot byen"
        case fromCity = "Ut fra byen"
        case undefined = ""
    }
    
    /**
        Initializer with lat/long as Floats
     */
    init(id: String, name: String, types: [String], longitude: Float, latitude: Float) {
        self.id = id
        self.name = name
        self.location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.departures = DepartureList()
        
        self.types = BusStop.getStopTypes(types)
        self.updateRealtimeDepartures()
        
    }
    
    /**
        Initializer with CLLocation
     */
    init(id: String, name: String, types: [String], location: CLLocation) {
        self.id = id
        self.name = name
        self.location = location
        self.departures = DepartureList()
        
        self.types = BusStop.getStopTypes(types)
        self.updateRealtimeDepartures()
    }
    
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        let id = try container.decode(String.self, forKey: .identification)
        let name = try container.decode(String.self, forKey: .name)
        
        let longitude = try container.decode(Float.self, forKey: .longitude)
        let latitude = try container.decode(Float.self, forKey: . latitude)
        let type = try container.decode([String].self, forKey: .type)
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))

        
        self.init(id: id, name: name, types: type, location: location)
        
    }
    
    private static func getStopTypes(_ type: [String]) -> [StopType] {
        var types = [StopType]()
        type.forEach {type in
            let theType: StopType
            switch (type) {
            case CodingKeys.busStop.rawValue:
                theType = .bus
            case CodingKeys.busStation.rawValue:
                theType = .bus
            case CodingKeys.railStation.rawValue:
                theType = .train
            case CodingKeys.tramStop.rawValue:
                theType = .tram
            case CodingKeys.metroStation.rawValue:
                theType = .metro
            case CodingKeys.ferryStop.rawValue:
                theType = .ferry
            case CodingKeys.airport.rawValue:
                theType = .airport
            default:
                fatalError("Got unexpected stoptype. Got: \(type)")
            }
            if(!types.contains(theType)) {
                types.append(theType)
            }
        }
        return types
    }
    
    
    func updateRealtimeDepartures() {
        APIController.shared.getRealtimeDeparturesForAPIRequest(busStop: self)
    }

}

