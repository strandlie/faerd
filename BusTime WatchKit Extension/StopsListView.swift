//
//  ListStopsView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct StopsListView : View {
    
    @ObservedObject var user: User = User.shared
    @ObservedObject var nearbyStops = BusStopList.shared
    
    // Uses the shared instance of user to access the current location
    let sortClosure = { (busStop1: BusStop, busStop2: BusStop) -> Bool in
        guard let distance1 = LocationController.actualDistanceBetween(location1: busStop1.location, location2: User.shared.currentLocation),
            let distance2 = LocationController.actualDistanceBetween(location1: busStop2.location, location2: User.shared.currentLocation) else {
                print("busStop1: \(busStop1), busStop2: \(busStop2), User location: \(String(describing: User.shared.currentLocation))")
                fatalError("Trying to compare distances of two locations that don't exist")
        }
        return distance1 < distance2
    }
    
    var body: some View {
        VStack {
            nearbyStops.stops.count == 0
            ? VStack {
                Spacer()
                Text("Ingen stopp i nærheten")
            }
            : nil
            
           
            List {
                NavigationLink(destination: SettingsView()) {
                    HStack {
                        Spacer()
                        Text("Innstillinger")
                            .font(.callout)
                        Spacer()
                    }
                }
                
                ForEach(nearbyStops.stops.sorted(by: sortClosure)){ busStop in
                    NavigationLink(destination: StopDetailView(
                                        stop: busStop,
                                        distance: self.nearbyStops.distances[busStop.id]!,
                                        departureList: busStop.departures))
                    {
                        HStack{
                            ZStack(alignment: .leading) {
                                Text("999 m")
                                    .opacity(0)
                                    .accessibility(hidden: true)
                                VStack {
                                    Text(self.nearbyStops.distances[busStop.id]!)
                                        .font(.caption)
                                }
                            }
                                .layoutPriority(0.4)
                            Image(busStop.types[0].rawValue)
                                .layoutPriority(0.4)
                            //TODO: Still not aligning to leading. Try with ZStack
                            VStack(alignment: .leading) {
                                Text(busStop.name)
                                    .font(.footnote)
                                    .bold()
                                    .truncationMode(.tail)
                                    .lineLimit(2)
                                    
                            }
                                .layoutPriority(0.3)
                        }
                            .navigationBarTitle(Text("Nærmeste"))
                    }.listRowPlatterColor(.red)
                }
            }.multilineTextAlignment(.center)
                    
        }.onAppear(perform: updateStops)
    }
    
    /*
     Update the nearbyStops, each time the StopsListView appears
     Currently there is a bug that makes it only get called
     the first time this view appears, but this is apparently fixed
     in XCode 11.2
     */
    private func updateStops() {
        if let currentLocation = User.shared.currentLocation {
            LocationController.shared.updateNearbyStopsTo(coordinate: currentLocation)
                
        }
    }
}

#if DEBUG
struct ListStopsView_Previews : PreviewProvider {
    static var previews: some View {
        StopsListView()
    }
}
#endif
