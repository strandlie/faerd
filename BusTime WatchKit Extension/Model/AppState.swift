//
//  AppState.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 24/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import Combine

final class AppState: ObservableObject {
    @Published var isFetching = false {
        didSet {
            if isFetching == true {
                print("Beginning fetching")
            } else {
                print("Done fetching")
            }
        }
    }
    
    static let shared = AppState()
}
