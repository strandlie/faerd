//
//  FavoritesView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 25/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct FavoritesView: View {

    @EnvironmentObject var favoriteList: FavoriteList
    
    // MARK: Localization
    let no_favorites: LocalizedStringKey = "no_favorites"
    let favorites: LocalizedStringKey = "favorites"
    let press: LocalizedStringKey = "press"
    let to_begin: LocalizedStringKey = "to_begin"
    let premium_favorites: LocalizedStringKey = "premium_favorites"
    let max_favorites: LocalizedStringKey = "max_favorites"
    let upgrade: LocalizedStringKey = "upgrade"
    let benefits: LocalizedStringKey = "benefits"
    
    var body: some View {
        ScrollView {
            favoriteList.favorites.count == 0
                ? VStack {
                    Spacer()
                    Text(no_favorites).lineLimit(2)
                    Spacer()
                    HStack {
                        Text(press)
                        IconController.getSystemIcon(for: .star)
                    }
                    Text(to_begin)
                }
            : nil
                        
            ForEach(favoriteList.favorites) { favorite in
                if favorite.destinationName == nil {
                    NavigationLink(destination: StopDetailView(stop: favorite.stop, distance: getDistance(from: favorite.stop), departureList: favorite.stop.departures)) {
                        FavoriteStopButton(stop: favorite.stop)
                    }
                } else {
                    NavigationLink(destination: LineDetailView(departureList: getDepartureList(from: favorite), stop: favorite.stop, distance: getDistance(from: favorite.stop))) {
                        FavoriteLineButton(originName: favorite.stop.name, publicCode: favorite.publicCode ?? "")
                    }
                }
            }.navigationBarTitle(favorites)
                .onAppear(perform: {self.favoriteList.favorites = FavoritesController.shared.getFavorites()})
            
            
            !favoriteList.canAddMoreFavorites()
                ? VStack {
                    HStack {
                        
                        Text(premium_favorites)
                            .font(.headline)
                            .lineLimit(2)
                        IconController.getSystemIcon(for: .star)
                            .colorMultiply(.yellow)
                    }
                    
                    Spacer()
                    Text(max_favorites)
                        .font(.body)
                    Button(action: {StoreController.shared.userWantsToBuy(feature: UserDefaultsKeys.premiumFavoritesStatus.rawValue)}) {
                        VStack {
                            Text(upgrade)
                                .font(.headline)
                            Text(StoreController.shared.premiumFavoritesProduct.regularPrice ?? "")
                                .colorMultiply(.blue)
                        }
                        
        
                    }
                    Text(benefits)
                        .font(.body)
                    
                    
                    }.padding()
            : nil

        }
        
    }
}

private func getDepartureList(from favorite: Favorite) -> DepartureList {
    guard let publicCode = favorite.publicCode, let destinationName = favorite.destinationName else {
        fatalError("Trying to get departures for non-Line Favorite")
    }
    let departureList = DepartureList()
    favorite.stop.updateRealtimeDepartures() {
        departureList.departures = favorite.stop.departures.filterDown(forPublicCode: publicCode, forDestinationName: destinationName)
    }
    return departureList
}

private func getDistance(from stop: BusStop) -> String {
    if let userLocation = User.shared.currentLocation {
        return LocationController.formattedDistanceBetween(location1: userLocation, location2: stop.location)
    }
    
    return "-"
}

struct FavoritesView_Previews: PreviewProvider {

    static let stop1 = BusStop(id: "1", name: "Bakkegata", types: [BusStop.CodingKeys.busStop.rawValue], longitude: 10.4075, latitude: 63.4322)
    static let stop2 = BusStop(id: "2", name: "Trondheim Sentralstasjon", types: [BusStop.CodingKeys.railStation.rawValue], longitude: 10.3992, latitude: 63.4360)
    static let destinationName1 = "Tyholt"
    static let publicCode1 = "22"
    
    static let favorite2 = Favorite(stop1, destinationName: destinationName1, publicCode: publicCode1)
    static  let favorite1 = Favorite(stop2)
    
    static var previews: some View {
        FavoritesView().environmentObject(FavoriteList([favorite1, favorite2]))
    }
}
