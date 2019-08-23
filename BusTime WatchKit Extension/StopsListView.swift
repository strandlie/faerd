//
//  ListStopsView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 21/06/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct StopsListView : View {
    
    @ObservedObject var user: User
    @ObservedObject var nearbyStops = BusStopList.shared
    
    var body: some View {
        VStack {
            List(nearbyStops.stops) { busStop in
                NavigationLink(destination: StopDetailView()) {
                    HStack{
                        Text(LocationController.formattedDistanceBetween(location1: busStop.location, location2: self.user.currentLocation))
                            .scaledToFill()
                            .font(.callout)
                                    
                        Text(busStop.name)
                            .scaledToFill()
                            .font(.system(size: 13))
                            .padding()
                    }.navigationBarTitle(Text("Stopp i nærheten"))
                }
            }
                    
        }
    }
}

#if DEBUG
struct ListStopsView_Previews : PreviewProvider {
    static var previews: some View {
        //StopsListView()
        StopsListView(user: User(initialLocation: CLLocation(latitude: 63.4329, longitude: 10.4090)))
    }
}
#endif
