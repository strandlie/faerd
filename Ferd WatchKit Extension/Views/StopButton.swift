//
//  StopButton.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 29/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI



struct StopButton: View {
    
    let distance: String
    let stop: BusStop
    
    var body: some View {
        HStack {
            ZStack(alignment: .leading) {
                Text("999 m")
                    .opacity(0)
                    .accessibility(hidden: true)
                VStack {
                    Text(distance)
                        .font(.subheadline)
                }
            }.layoutPriority(0.4)
            IconController.getIcon(for: stop.types[0].rawValue)
                .layoutPriority(0.4)
            
            VStack(alignment: .leading) {
                Text(stop.name)
                    .truncationMode(.tail)
                    .lineLimit(2)
                    
            }.layoutPriority(0.3)
            Spacer()
        }
    }
}

struct StopButton_Previews: PreviewProvider {
    
    static let stop = BusStop(id: "2", name: "Trondheim Sentralstasjon", types: [BusStop.CodingKeys.railStation.rawValue], longitude: 10.3992, latitude: 63.4360)
    
    static var previews: some View {
        StopButton(distance: "32m", stop: stop)
    }
}
