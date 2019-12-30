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
    @EnvironmentObject var appState: AppState
    

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
        GeometryReader { geometry in
            ZStack {
                VStack {
                    self.nearbyStops.stops.count == 0
                    ? VStack {
                        Spacer()
                        Text("Ingen stopp i nærheten")
                    }
                    : nil
                    
                    ScrollView {
                        HStack {
                            Button(action: { print("User wants to see favorites") }) {
                                Image(systemName: "star.fill")
                                    .font(.system(size: 28))
                                    .colorMultiply(.yellow)
                            }
                            NavigationLink(destination: SettingsView()) {
                                    Image(systemName: "gear")
                                        .font(.system(size: 28))
                            }.background(Color.blue.cornerRadius(5))
                            if (self.appState.isFetching)  {
                                Button(action: {print("Something")}) {
                                    ActivityIndicator()
                                    .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                                }.disabled(true)
                            } else {
                                Button(action: { self.updateStops()}) {
                                    Image(systemName: "arrow.clockwise")
                                        .font(.system(size: 28))
                                }
                            }
                        }
                        
                        ForEach(self.nearbyStops.stops.sorted(by: self.sortClosure)){ busStop in
                            NavigationLink(destination: StopDetailView(
                                                stop: busStop,
                                                distance: self.nearbyStops.distances[busStop.id]!,
                                                departureList: busStop.departures))
                            {
                                StopButton(distance: self.nearbyStops.distances[busStop.id]!, stop: busStop)
                            }
                        }
                    }
                            
                }
                .onAppear(perform: self.updateStops)
            }
        }
    }
    

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
