//
//  DepartureList.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 22/09/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

class DepartureList: ObservableObject {
    
    @Published var departures: [Departure]
    
    func filterDown(forPublicCode publicCode: String, forDestinationName destinationName: String) -> [Departure] {
        return departures.filter { departure in departure.publicCode == publicCode && departure.destinationName == destinationName
        }
    }
    
    init(departures: [Departure]) {
        self.departures = departures
    }
    
    
    init() {
        self.departures = []
       
    }
    
    
}
