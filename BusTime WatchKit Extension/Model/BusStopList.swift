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
    @Published var stops: [BusStop]
    
    static let shared = BusStopList()
    
    init() {
        self.stops = [
            BusStop(id: 16010050, name: "Bakkegata", location: CLLocation(latitude: 63.4324, longitude: 10.4073), lines: [1, 2, 3]),
            BusStop(id: 16010404, name: "Solsiden", location:
            CLLocation(latitude: 63.4340, longitude: 10.4135), lines: [1, 2, 3]),
            BusStop(id: 16010022, name: "Olav Tryggvasons gate 2", location:
            CLLocation(latitude: 63.4333, longitude:
                10.4012), lines: [1, 2, 3]),
            BusStop(id: 16010017, name: "Olav Tryggvasons gate 3", location: CLLocation(latitude: 63.4338, longitude: 10.4003), lines: [1, 2, 3])
        ]
    }
    
    func setNearbyStops(_ stops: [BusStop]) {
        self.stops = stops
    }
}
