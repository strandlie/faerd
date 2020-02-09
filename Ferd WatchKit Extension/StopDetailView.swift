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
    
    // MARK: Localization
    static let now: LocalizedStringKey = "now"
    let no_departures: LocalizedStringKey = "no_departures"
    let departures: LocalizedStringKey = "departures"
    let load_more: LocalizedStringKey = "load_more"
    let max_favorites: LocalizedStringKey = "max_favorites"
    let premium_required: LocalizedStringKey = "premium_required"
    let upgrade_for_unlimited: LocalizedStringKey = "upgrade_for_unlimited"
    let upgrade: LocalizedStringKey = "upgrade"
    let keep_free: LocalizedStringKey = "keep_free"
    
    @ObservedObject var departureList: DepartureList
    @EnvironmentObject var favoriteList: FavoriteList
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var numDeparturesToLoad = 20
    @State var favoritesWarningIsPresented = false
    
    static let filterClosure = { (departure: Departure) -> Bool in
        return departure.time.timeIntervalSinceNow >= 0
    }
    
    static let sortClosure = { (departure1: Departure, departure2: Departure) -> Bool in
        return departure1.time.timeIntervalSinceNow < departure2.time.timeIntervalSinceNow
    }
    
    var body: some View {
        ScrollView {
            VStack {
                Text(stop.name)
                    .bold()
                    .lineLimit(3)
                    .font(.title)
                    .truncationMode(.middle)
                HStack {
                    Button(action: {
                        if (self.favoriteList.existsLocationFavorite(for: self.stop) || self.favoriteList.canAddMoreFavorites()) {
                            self.favoritesWarningIsPresented = false
                            self.toggleFavorite()
                        } else {
                            self.favoritesWarningIsPresented = true
                        }
                        
                    })
                    {
                        IconController.getSystemIcon(for: .star)
                            .colorMultiply(favoriteList.existsLocationFavorite(for: stop) ? .yellow : .white)
                    }.frame(width: 50)
                        
                    Text(distance)
                        .font(.headline)
                    ForEach(stop.types, id: \.self) { type in
                        IconController.getIcon(for: type.rawValue)
                            .font(.title)
                    }
                }
            }
            departureList.departures.count == 0
                ? VStack{
                    Text(no_departures)
                    }
                : nil
            ForEach(departureList.departures.filter(StopDetailView.filterClosure).sorted(by: StopDetailView.sortClosure).prefix(numDeparturesToLoad)) { departure in
                
                NavigationLink(destination: LineDetailView(departureList: DepartureList(departures: self.departureList.filterDown(forPublicCode: departure.publicCode, forDestinationName: departure.destinationName)), stop: self.stop, distance: self.distance)) {
        
                    HStack {
                        ZStack(alignment: .leading) {
                            Text("123")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.publicCode)
                                .font(.subheadline)
                        }
                        ZStack(alignment: .leading) {
                            Text("111111111111111111")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.destinationName)
                                .font(.headline)
                                .truncationMode(.tail)
                                .lineLimit(2)
                        }
                        ZStack(alignment: .trailing) {
                            Text("22:30")
                                .opacity(0)
                                .accessibility(hidden: true)
                            departure.time.timeIntervalSinceNow > 45
                            ? Text(departure.timeToDeparture)
                                .italic()
                                .font(.headline)
                                .foregroundColor(departure.isRealTime ? .yellow : .white)
                            : Text(StopDetailView.now)
                                .italic()
                                .font(.headline)
                                .foregroundColor(departure.isRealTime ? .yellow : .white)
                        }
                    }
                }
                
            }
            departureList.departures.count > 20
            ? Button(action: { self.numDeparturesToLoad += 20 }) {
                Text(load_more)
                    .font(.headline)
            }.background(Color.blue.cornerRadius(5).opacity(0.75))
            : nil
        }
        .navigationBarTitle(departures)
        .onReceive(self.appState.$isInForeground) { value in
            if !value {
                self.presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $favoritesWarningIsPresented, content: {
            Alert(title: Text(premium_required),
                  message: Text(max_favorites) + Text("\n\n") + Text(upgrade_for_unlimited),
                  primaryButton: .default(Text(upgrade)) {
                    StoreController.shared.userWantsToBuyPremiumFavorites()
                    self.favoritesWarningIsPresented = false
                    } , secondaryButton: .destructive(Text(keep_free)) {
                    self.favoritesWarningIsPresented = false
                })
            
        })
    }
    
    private func toggleFavorite() {
        if let existingFavorite = self.favoriteList.getLocationFavorite(for: self.stop) {
            self.favoriteList.remove(existingFavorite)
        } else {
            self.favoriteList.append(Favorite(self.stop))
        }
    }
    
}

#if DEBUG
struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyView()
    }
}
#endif
