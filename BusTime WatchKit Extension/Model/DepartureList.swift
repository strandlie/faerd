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
    
    
    init() {
        self.departures = []
        /*self.departures = [
            Departure(busStop: BusStop(id: "1", name: "Nidaros", longitude: 10.4058, latitude: 63.4308), time: Date().advanced(by: 60), isRealTime: true, destinationName: "City Syd via Gløshaugen", publicCode: "22")
        */
    }
    
    
}
