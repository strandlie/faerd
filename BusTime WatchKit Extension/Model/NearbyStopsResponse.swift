//
//  NearbyStopsResponse.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 02/10/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

struct NearbyStopsResponse: Decodable {
    struct Feature: Decodable {
        struct Geometry: Decodable {
            let coordinates: [Float]
            var longitude: Float {
                get {
                    return coordinates[0]
                }
            }
            var latitude: Float {
                get {
                    return coordinates[1]
                }
            }
        }
        
        struct Properties: Decodable {
            let id: String
            let name: String
        }
        
        let geometry: Geometry
        let properties: Properties
    
    }
    
    let features: [Feature]
}
