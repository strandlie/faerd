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
    
    static let imageColorMapping: Dictionary<String, Color> = [
        BusStop.StopType.bus.rawValue: .red,
        BusStop.StopType.train.rawValue: .blue,
        BusStop.StopType.tram.rawValue: .green,
        BusStop.StopType.metro.rawValue: .orange,
        BusStop.StopType.ferry.rawValue: .yellow,
        BusStop.StopType.airport.rawValue: .purple,
        Favorite.FavoriteType.stop.rawValue: .white,
        Favorite.FavoriteType.departure.rawValue: .pink
    ]
    
    static func getIcon(for stopType: String) -> some View {
        return Image(stopType)
                .renderingMode(.original)
                .colorInvert()
                .colorMultiply(imageColorMapping[stopType] ?? .accentColor)
    }
    
    
    
}
