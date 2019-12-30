//
//  FavoritesView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 25/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {
    
    @ObservedObject var favoriteList: FavoriteList
    
    
    var body: some View {
        List(favoriteList.favorites) { favorite in
            if favorite.destinationName == nil {
                NavigationLink(destination: StopDetailView(stop: favorite.stop, distance: "132 m", departureList: favorite.stop.departures)) {
                    FavoriteStopButton(stop: favorite.stop)
                }
            } else {
                NavigationLink(destination: LineDetailView(departureList: DepartureList(departures: []), stop: favorite.stop, distance: "48m")) {
                    FavoriteLineButton(destinationName: favorite.destinationName ?? "", publicCode: favorite.publicCode ?? "")
                }
            }
        }.navigationBarTitle("Favoritter")
    }
}

private func getDepartures(for favorite: Favorite) {
    favorite.stop.updateRealtimeDepartures()
    
}

struct FavoritesView_Previews: PreviewProvider {

    static let stop1 = BusStop(id: "1", name: "Bakkegata", types: [BusStop.CodingKeys.busStop.rawValue], longitude: 10.4075, latitude: 63.4322)
    static let stop2 = BusStop(id: "2", name: "Trondheim Sentralstasjon", types: [BusStop.CodingKeys.railStation.rawValue], longitude: 10.3992, latitude: 63.4360)
    static let destinationName1 = "Tyholt"
    static let publicCode1 = "22"
    
    static let favorite2 = Favorite(stop1, destinationName: destinationName1, publicCode: publicCode1)
    static  let favorite1 = Favorite(stop2)
    
    static var previews: some View {
        FavoritesView(favoriteList: FavoriteList(favorites: [favorite1, favorite2]))
    }
}
