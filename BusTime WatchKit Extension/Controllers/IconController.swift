//
//  IconController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 19/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import SwiftUI

struct IconController {
    
    static let imageColorMapping: Dictionary<BusStop.StopType, Color> = [
        .bus: .red,
        .train: .blue,
        .tram: .green,
        .metro: .orange,
        .ferry: .yellow,
        .airport: .purple
    ]
    
    static func getIcon(for stopType: BusStop.StopType) -> some View {
        return Image(stopType.rawValue)
                .renderingMode(.original)
                .colorInvert()
                .colorMultiply(imageColorMapping[stopType] ?? .accentColor)
    }
    
    
    
}
