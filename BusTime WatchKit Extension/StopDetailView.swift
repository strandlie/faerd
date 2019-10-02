//
//  StopDetailView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 16/08/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI
import Combine

struct StopDetailView: View {
    let stop: BusStop
    let distance: String
    
    var departureList: DepartureList
    
    
    var body: some View {
        VStack {
            Text(stop.name)
                .bold()
                .font(.subheadline)
                .truncationMode(.middle)
            Text(distance)
                .bold()
            
            List(departureList.departures) { departure in
                HStack {
                    ZStack(alignment: .leading) {
                        Text("123")
                            .opacity(0)
                            .accessibility(hidden: true)
                        Text(departure.publicCode)
                            .bold()
                            .font(.callout)
                    }
                    ZStack(alignment: .leading) {
                        Text("111111111111111111")
                            .opacity(0)
                            .accessibility(hidden: true)
                        Text(departure.destinationName)
                            .truncationMode(.tail)
                            .lineLimit(2)
                    }
                    ZStack(alignment: .trailing) {
                        Text("22:30")
                            .opacity(0)
                            .accessibility(hidden: true)
                        Text(departure.timeToDeparture)
                            .italic()
                            .font(.callout)
                            .foregroundColor(departure.isRealTime ? .yellow : .white)
                        
                    }
                    
                }
            }.disabled(true)
        }
        .navigationBarTitle("Avganger")
    }
}

#if DEBUG
struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stop: BusStop(id: "16010050", name: "Studentersamfundet 3", location: CLLocation(latitude: 63.4324, longitude: 10.4073)), distance: "104m", departureList: DepartureList())
    }
}
#endif
