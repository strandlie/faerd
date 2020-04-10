//
//  LineDetailView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 16/10/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct LineDetailView: View {
    @ObservedObject var departureList: DepartureList
    @EnvironmentObject var favoriteList: FavoriteList
    
    @State var favoritesWarningIsPresented = false
    let premiumPrice = StoreController.shared.premiumFavoritesProduct?.regularPrice ?? " "
    
    // MARK: Localization
    let to: LocalizedStringKey = "to"
    let departures_in: LocalizedStringKey = "departures_in"
    let realtime: LocalizedStringKey = "realtime"
    let no_departures: LocalizedStringKey = "no_departures"
    let upgrade: LocalizedStringKey = "upgrade"
    let max_favorites: LocalizedStringKey = "max_favorites"
    let premium_required: LocalizedStringKey = "premium_required"
    let upgrade_for_unlimited: LocalizedStringKey = "upgrade_for_unlimited"
    let keep_free: LocalizedStringKey = "keep_free"
    
    let stop: BusStop
    let distance: String
    
    private var publicCode: String {
        return departureList.departures.count > 0 ? departureList.departures[0].publicCode : ""
    }
    
    private var destinationName: String {
        return departureList.departures.count > 0 ? departureList.departures[0].destinationName : ""
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text(publicCode)
                    .bold()
                    .lineLimit(2)
                    .font(.title)
                Button(action: {
                    if (self.favoriteList.existsLineFavorite(for: self.stop, destinationName: self.destinationName, publicCode: self.publicCode) || self.favoriteList.canAddMoreFavorites()) {
                        self.favoritesWarningIsPresented = false
                        self.toggleFavorite()
                    } else {
                        self.favoritesWarningIsPresented = true
                    }
                        
                }) {
                    IconController.getSystemIcon(for: .star)
                        .colorMultiply(favoriteList.existsLineFavorite(for: stop, destinationName: destinationName, publicCode: publicCode) ? .yellow : .white)
                }.frame(width: 50)

                
            }
            
            Text(to)
            Text(destinationName)
                .font(.headline)
                .truncationMode(.middle)
            
            
            Divider().background(Color.red)
            ForEach(departureList.departures.filter(StopDetailView.filterClosure)) { departure in
                HStack {
                    departure.time.timeIntervalSinceNow > 45
                    ? Text(departure.timeToDeparture)
                        .font(.system(size: 19))
                        .foregroundColor(departure.isRealTime ? .yellow : .white)
                        : Text(StopDetailView.now)
                            .font(.system(size: 19))
                            .foregroundColor(departure.isRealTime ? .yellow : .white)
                }
                Spacer()
                
            }
            departureList.departures.count == 0
            ? VStack {
                Text(no_departures)
            }
            : nil
            
            departureList.departures.count > 0
            ? VStack {
                Divider()
                HStack {
                    Text(departures_in)
                    Text(realtime).foregroundColor(.yellow)
                    
                }
            }
            : nil
            
        }
        .alert(isPresented: $favoritesWarningIsPresented, content: {
            Alert(title: Text(premium_required),
                  message: Text(max_favorites) + Text("\n\n") + Text(upgrade_for_unlimited),
                  primaryButton: .default(Text(upgrade) + Text(" (\(premiumPrice))")) {
                    StoreController.shared.userWantsToBuy(feature: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
                    self.favoritesWarningIsPresented = false
                },
                  secondaryButton: .destructive(Text(keep_free)) {
                    self.favoritesWarningIsPresented = false
            })
        })
        .navigationBarTitle(stop.name)
    }
    
    private func toggleFavorite() {
        if let existingFavorite = self.favoriteList.getLineFavorite(for: self.stop, destinationName: destinationName, publicCode: publicCode) {
            self.favoriteList.remove(existingFavorite)
        } else {
            self.favoriteList.append(Favorite(self.stop, destinationName: destinationName, publicCode: publicCode))
        }
    }
}

struct LineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
