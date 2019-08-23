//
//  User.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 23/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import CoreLocation
import SwiftUI
import Combine

class User: ObservableObject {
    
    typealias PublisherType = PassthroughSubject<Void, Never>
    
    var willChange = PublisherType()
    var currentLocation: CLLocation? {
        didSet {
            //print("New location set: \(currentLocation)")
            self.willChange.send(Void())
            
        }
    }
    
    static let shared = User()
    
    convenience init(initialLocation: CLLocation) {
        self.init()
        self.currentLocation = initialLocation
    }
    
    func getNearbyStops() -> [BusStop] {
        guard let currentLocation = currentLocation else {
            return []
        }
        return LocationController.shared.getNearbyStopsTo(coordinate: currentLocation)
    }
    
}
