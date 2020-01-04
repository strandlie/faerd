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
        BusStop.StopType.lift.rawValue: .white,
        Favorite.FavoriteType.stop.rawValue: .white,
        Favorite.FavoriteType.departure.rawValue: .pink
    ]
    
    static func getIcon(for stopType: String) -> some View {
        return Image(stopType)
                .renderingMode(.original)
                .colorInvert()
                .colorMultiply(imageColorMapping[stopType] ?? .accentColor)
    }
    
    static func getSystemIcon(for name: SystemIcons) -> some View {
        switch name {
        case .star:
            return Image(systemName: name.rawValue)
                        .font(.system(size: 28))
        case .gear:
            return Image(systemName: name.rawValue)
                        .font(.system(size: 28))
        case .refresh:
            return Image(systemName: name.rawValue)
                        .font(.system(size: 28))
        }
    }
    
    enum SystemIcons: String {
        case star = "star.fill"
        case gear = "gear"
        case refresh = "arrow.clockwise"
    }
    
    
    
}
