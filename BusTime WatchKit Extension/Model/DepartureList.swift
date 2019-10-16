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
    
    func forPublicCode(_ publicCode: String) -> [Departure] {
        return departures.filter { departure in departure.publicCode == publicCode
        }
    }
    
    init(departures: [Departure]) {
        self.departures = departures
    }
    
    
    init() {
        self.departures = []
        let departure1 = Departure(time: Date(),
                                   isRealTime: true,
                                   destinationName: "Tyholt",
                                   publicCode: "22")
        let departure2 = Departure(time: Date(),
                                   isRealTime: false,
                                   destinationName: "Strindheim",
                                   publicCode: "4")
        self.departures = [departure1, departure2]
    }
    
    
}
