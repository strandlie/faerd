//
//  Departure.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 08/09/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

class Departure {
    let busStop: BusStop
    let time: Date
    var isRealTime: Bool
    
    init(busStop: BusStop, time: Date, isRealTime: Bool) {
        self.busStop = busStop
        self.time = time
        self.isRealTime = isRealTime
    }
}
