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
    
    let id: Int
    let name: String // Name of BusStop
    let location: CLLocation
    let lines: [String]
    let direction: Direction
    let departures: [Departure] = []
    
    enum CodingKeys: String, CodingKey {
        case longitude = "x"
        case latitude = "y"
        case identification = "v"
        case name = "n"
        case lines = "l"
        case serviceTypes = "st"
        case zone
    }
    
    enum Direction: String {
        case towardsCity = "Inn mot byen"
        case fromCity = "Ut fra byen"
        case undefined = ""
    }
    
    /**
        Initializer with lat/long as Floats
     */
    init(id: Int, name: String, longitude: Float, latitude: Float, lines: [String], direction: Direction) {
        self.id = id
        self.name = name
        self.location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        self.lines = lines
        self.direction = direction
        
        self.getRealtimeDepartures()
        
    }
    
    /**
        Initializer with CLLocation
     */
    init(id: Int, name: String, location: CLLocation, lines: [String], direction: Direction) {
        self.id = id
        self.name = name
        self.location = location
        self.lines = lines
        self.direction = direction
        
        self.getRealtimeDepartures()
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
       
        let id = BusStop.getCorrectIdFrom(initial: try container.decode(String.self, forKey: .identification))
        let name = BusStop.getShortNameFrom(fullName: try container.decode(String.self, forKey: .name))
        let direction = BusStop.getDirectionFrom(id: id)
        
        let longitude = try container.decode(Float.self, forKey: .longitude)
        let latitude = try container.decode(Float.self, forKey: . latitude)
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let lines = try container.decode(Array<String>.self, forKey: .lines)
        
        self.init(id: id, name: name, location: location, lines: lines, direction: direction)
        
    }
    
    
    
    init(fromFullName fullName: String, fromInitialId initialId: String, longitude: Double, latitude: Double, lines: Array<String> ) {
        let name = BusStop.getShortNameFrom(fullName: fullName)
        let id = BusStop.getCorrectIdFrom(initial: initialId)
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        let direction = BusStop.getDirectionFrom(id: id)
        
        
        self.init(id: id, name: name, location: location, lines: lines, direction: direction)
    }
    
    /*
        Extract stopID from identification-field
        If identification does not contain : something is very broken
    */
    static func getCorrectIdFrom(initial: String) -> Int {
        let colonRange: Range<String.Index> = initial.range(of: ":")!
        let newId = String(initial[initial.startIndex..<colonRange.lowerBound])
        return Int(newId)!
    }
    
    /*
        Extract name from name-field. This means removing
        the (Trondheim) substring
    */
    static func getShortNameFrom(fullName: String) -> String {
        guard let paranthesisRange: Range<String.Index> = fullName.range(of: "(") else {
            fatalError("Unexpected format. No paranthesis in identification of BusStop.")
        }
        let shortName = String(fullName[fullName.startIndex..<paranthesisRange.lowerBound])
        return String(shortName).trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    /**
        Extract the direction from the id. The logic is assumed to be:
     
        If the 5'th position in the ID is '1', then the bus has direction towards the city centre
        else the 5'th position is '0' and the bus has direction from the city centre.
     
        This should be properly tested.
     */
    static func getDirectionFrom(id: Int) -> Direction {
        let id = String(id)
        if id.count == 8 {
            let index5 = id.index(id.startIndex, offsetBy: 4)
            let position5 = String(id[index5])
            
            return position5 == "1" ? .towardsCity : .fromCity
        }
        return .undefined
    }
    
    func getRealtimeDepartures() {
        APIController.shared.getRealtimeDeparturesForAPIRequest(busStop: self)
    }
}

