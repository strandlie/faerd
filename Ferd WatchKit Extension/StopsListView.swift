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
    
    // MARK: Localization
    let no_stops: LocalizedStringKey = "no_stops"
    let no_location_access: LocalizedStringKey = "no_location_access"
    let open_iphone: LocalizedStringKey = "open_iphone"
    let instructions: LocalizedStringKey = "instructions"
    
    /*
        This is hacky and not really consistent with the semantics of @State.
        Really want to fetch this with a binding from settings, but can't make
        it work without proper error messages from SwiftUI.
    */
    @State private var firstViewSelection: Int? = Settings.shared.firstScreenSelection.hashValue
    
    static let filterClosure = { (busStop: BusStop) -> Bool in
        return busStop.departures.departures.count > 0
    }

    // Uses the shared instance of user to access the current location
    static let sortClosure = { (busStop1: BusStop, busStop2: BusStop) -> Bool in
        guard let distance1 = User.shared.actualDistance(to: busStop1.location),
            let distance2 = User.shared.actualDistance(to: busStop2.location) else {
                print("busStop1: \(busStop1), busStop2: \(busStop2), User location: \(String(describing: User.shared.currentLocation))")
                fatalError("Trying to compare distances of two locations that don't exist")
        }
        return distance1 < distance2
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack {
                    
                    // Handle when no stops are returned from the API
                    self.nearbyStops.stops.count == 0 && self.appState.hasLocationAccess
                    ? VStack {
                        Spacer()
                        Text(self.no_stops)
                    }
                    : nil
                    
                    // Handle when location is not enabled
                    (!self.appState.hasLocationAccess)
                    ? ScrollView {
                        HStack {
                            IconController.getSystemIcon(for: .danger)
                                .colorMultiply(.red)
                            Text(self.no_location_access).font(.headline)
                        }
                        Divider()
                        HStack {
                            Text(self.open_iphone).bold()
                            Spacer()
                        }
                        Spacer()
                        HStack {
                            Text(self.instructions).font(.body)
                            Spacer()
                        }
                    }
                    : nil
                    
                    self.appState.hasLocationAccess
                    ? ScrollView {
                        HStack {
                            NavigationLink(destination: FavoritesView(), tag: FirstScreenSelection.favorites.hashValue, selection: self.$firstViewSelection) {
                                IconController.getSystemIcon(for: .star)
                                    .colorMultiply(.yellow)
                            }
                            NavigationLink(destination: SettingsView()) {
                                IconController.getSystemIcon(for: .gear)
                            }.background(Color.blue.cornerRadius(5))
                            if (self.appState.isFetching)  {
                                Button(action: { }) {
                                    ActivityIndicator()
                                    .frame(width: geometry.size.width / 8, height: geometry.size.height / 8)
                                }.disabled(true)
                            } else {
                                Button(action: { self.updateStops()}) {
                                    IconController.getSystemIcon(for: .refresh)
                                }
                            }
                        }
                        
                        ForEach(self.nearbyStops.stops.filter(StopsListView.filterClosure).sorted(by: StopsListView.sortClosure)){ busStop in
                            NavigationLink(destination: StopDetailView(
                                                stop: busStop,
                                                distance: self.nearbyStops.distances[busStop.id]!,
                                                departureList: busStop.departures))
                            {
                                StopButton(distance: self.nearbyStops.distances[busStop.id]!, stop: busStop)
                            }
                        }
                    }
                    : nil
                            
                }
            }
        }.navigationBarTitle("Ferd")
    }
    

    private func updateStops() {
        // Update nearby stops
        if let currentLocation = User.shared.currentLocation {
            LocationController.shared.updateNearbyStopsTo(coordinate: currentLocation)
                
        }
        
        // Update departures for those stops
        self.nearbyStops.updateDepartures()
        
        // Clean up irrelevant stops
        DispatchQueue.main.async {
            self.nearbyStops.clean()
        }
    }
}

#if DEBUG
struct ListStopsView_Previews : PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
#endif
