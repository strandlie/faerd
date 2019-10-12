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
    static let shared = User()
    
    @Published var currentLocation: CLLocation?
        
    
    convenience init(initialLocation: CLLocation?) {
        self.init()
        self.currentLocation = initialLocation
    }
    
}
