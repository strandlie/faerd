//
//  Favorite.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 25/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import Combine

class Favorite: ObservableObject, Identifiable, Equatable {
    
   static func == (lhs: Favorite, rhs: Favorite) -> Bool {
    return lhs.id == rhs.id
      }
    
    let id: String
    let stop: BusStop
    let destinationName: String?
    let publicCode: String?
    
    init(_ stop: BusStop, destinationName: String? = nil, publicCode: String? = nil) {
        self.id = UUID().uuidString
        self.stop = stop
        self.destinationName = destinationName
        self.publicCode = publicCode
    }
    
    enum FavoriteType: String {
        case stop = "Stop"
        case departure = "Departures"
    }
    
}

