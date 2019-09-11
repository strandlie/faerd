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
            List(nearbyStops.stops.filter({_ in true/*$0.lines.count > 0*/}).sorted(by: sortClosure)) { busStop in
                NavigationLink(destination: StopDetailView(stop: busStop, distance: self.nearbyStops.distances[busStop.id]!)) {
                    HStack(){
                        ZStack(alignment: .leading) {
                            Text("999 m")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(self.nearbyStops.distances[busStop.id]!)
                                .font(.caption)
                        }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(busStop.name)
                                .bold()
                                .truncationMode(.tail)
                                .font(.callout)
                                .lineLimit(2)
                                
                        }
                           
                    }.navigationBarTitle(Text("Nærmeste"))
                }
            }
                    
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
