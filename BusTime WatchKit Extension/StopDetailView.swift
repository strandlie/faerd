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
    
    @ObservedObject var departureList: DepartureList
    
    let filterClosure = { (departure: Departure) -> Bool in
        return departure.time.timeIntervalSinceNow >= 0
    }
    
    // TODO: When the user presses a departure, show all departures for that
    // line by filtering the currently viewed departures, and pushing a
    // new StopDetailView
    var body: some View {
        VStack {
            VStack {
                Text(stop.name)
                    .bold()
                    .lineLimit(2)
                    .font(.footnote)
                    .truncationMode(.middle)
                HStack {
                    Text(distance)
                        .font(.footnote)
                    ForEach(stop.types, id: \.self) { type in
                        Image(type.rawValue).colorInvert()
                    }
                }
            }
            departureList.departures.count == 0
                ? VStack{
                    Spacer()
                    Text("Ingen avganger.")
                    }
                : nil
            List(departureList.departures.filter(filterClosure)) { departure in
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
                        Text(departure.formatTime(departure.time))
                            .italic()
                            .font(.callout)
                            .foregroundColor(departure.isRealTime ? .yellow : .white)
                    }
                }
            }.disabled(true)
         
        }
        .navigationBarTitle("Avganger")
        .onAppear(perform: updateDepartures)
        
    }
    
    private func updateDepartures() {
        stop.updateRealtimeDepartures()
    }
}

#if DEBUG
struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stop: BusStop(id: "16010050", name: "Studentersamfundet 3", types: ["onStreetBus"], location: CLLocation(latitude: 63.4324, longitude: 10.4073)), distance: "104m", departureList: DepartureList())
    }
}
#endif
