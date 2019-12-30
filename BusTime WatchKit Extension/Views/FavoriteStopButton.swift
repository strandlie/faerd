//
//  FavoriteStopButton.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 30/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct FavoriteStopButton: View {
   let stop: BusStop
    
    var body: some View {
        HStack {
            IconController.getIcon(for: Favorite.FavoriteType.stop.rawValue)
                .layoutPriority(0.6)
            
            VStack(alignment: .leading) {
                Text(stop.name)
                    .font(.body)
                    .truncationMode(.tail)
                    .lineLimit(2)
                    
            }.layoutPriority(0.4)
            Spacer()
        }
    }
}

struct FavoriteStopButton_Previews: PreviewProvider {
    static let stop = BusStop(id: "2", name: "Trondheim Sentralstasjon", types: [BusStop.CodingKeys.railStation.rawValue], longitude: 10.3992, latitude: 63.4360)
    static var previews: some View {
        FavoriteStopButton(stop: stop)
    }
}
