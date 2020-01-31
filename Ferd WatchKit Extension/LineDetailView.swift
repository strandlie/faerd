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
    
    // MARK: Localization
    let to: LocalizedStringKey = "to"
    let departures_in: LocalizedStringKey = "departures_in"
    let realtime: LocalizedStringKey = "realtime"
    let no_departures: LocalizedStringKey = "no_departures"
    
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
                Button(action: { self.toggleFavorite() }  ) {
                    IconController.getSystemIcon(for: .star)
                        .colorMultiply(favoriteList.existsLineFavorite(for: stop, destinationName: destinationName, publicCode: publicCode) ? .yellow : .white)
                }.frame(width: 50)
                .layoutPriority(0.2)
                VStack {
                    HStack {
                        Text(publicCode)
                            .bold()
                            .lineLimit(2)
                            .font(.subheadline)
                        Text(to)
                        
                    }
                    HStack {
                        Text(destinationName)
                            .bold()
                            .lineLimit(2)
                            .font(.headline)
                            .truncationMode(.middle)
                    }
                    
                }.layoutPriority(0.8)
            }

            Divider().background(Color.red)
            ForEach(departureList.departures.filter(StopDetailView.filterClosure)) { departure in
                HStack {
                    departure.time.timeIntervalSinceNow > 45
                    ? Text(departure.timeToDeparture)
                        .font(.callout)
                        .foregroundColor(departure.isRealTime ? .yellow : .white)
                        : Text(StopDetailView.now)
                        .font(.callout)
                            .foregroundColor(departure.isRealTime ? .yellow : .white)
                }
                Spacer()
                
            }
            departureList.departures.count == 0
            ? VStack{
                Text(no_departures)
                }
            : nil
            Divider()
            HStack {
                Text(departures_in)
                Text(realtime).foregroundColor(.yellow)
                
            }
        }
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
        Spacer()
    }
}
