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
    let lines: [Int]
    
    enum CodingKeys: String, CodingKey {
        case longitude = "x"
        case latitude = "y"
        case identification = "v"
        case name = "n"
        case lines = "l"
        case serviceTypes = "st"
        case zone
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        var identification = try container.decode(String.self, forKey: .identification)
        
        /*
            Extract stopID from identification-field
            If identification does not contain : something is very broken
        */
        let colonRange: Range<String.Index> = identification.range(of: ":")!
        identification = String(identification[identification.startIndex..<colonRange.lowerBound])
        let id = Int(identification)!
        
        /*
            Extract name from name-field. This means removing
            the (Trondheim) substring
         */
        var longName = try container.decode(String.self, forKey: .name)
        let parantRange: Range<String.Index> = longName.range(of: "(")!
        longName = String(longName[longName.startIndex..<parantRange.lowerBound])
        let name = String(longName).trimmingCharacters(in: .whitespacesAndNewlines)
        
        let longitude = try container.decode(Float.self, forKey: .longitude)
        let latitude = try container.decode(Float.self, forKey: . latitude)
        
        let location = CLLocation(latitude: CLLocationDegrees(latitude), longitude: CLLocationDegrees(longitude))
        
        let lines = try container.decode(Array<Int>.self, forKey: .lines)
        
        self.init(id: id, name: name, location: location, lines: lines)
        
        
    }
    
    init(id: Int, name: String, location: CLLocation, lines: [Int]) {
        self.id = id
        self.name = name
        self.location = location
        self.lines = lines
    }
}

