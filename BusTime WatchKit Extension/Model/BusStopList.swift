//
//  BusStopList.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 19/08/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation

class BusStopList: ObservableObject {
    
    static let shared = BusStopList()
    
    @Published var stops: [BusStop] {
        didSet {
            stops.forEach {
                distances[$0.id] = LocationController.formattedDistanceBetween(location1: $0.location, location2: User.shared.currentLocation)
            }
        }
    }
    
    var distances: [String: String]
    
    func get(for id: String) -> BusStop? {
        return stops.first { $0.id == id }
    }
    
    func append(_ stop: BusStop) {
        if self.stops.contains(stop) {
            distances[stop.id] = LocationController.formattedDistanceBetween(location1: stop.location, location2: User.shared.currentLocation)
        } else {
            self.stops.append(stop)
        }
    }
    
    init() {
        /*self.stops = [
            BusStop(id: "16010050", name: "Bakkegata", location: CLLocation(latitude: 63.4324, longitude: 10.4073)),
            BusStop(id: "16010404", name: "Solsiden", location:
                CLLocation(latitude: 63.4340, longitude: 10.4135)),
            BusStop(id: "16010022", name: "Olav Tryggvasons gate 2", location:
            CLLocation(latitude: 63.4333, longitude:
                10.4012)),
            BusStop(id: "16010017", name: "Olav Tryggvasons gate 3", location: CLLocation(latitude: 63.4338, longitude: 10.4003))
        ]*/
        self.stops = []
        self.distances = [:]
        //self.distances = ["16010050":"50 m", "16010404": "70 m", "16010022": "200 m", "16010017": "230 m"]
    }
    
}
