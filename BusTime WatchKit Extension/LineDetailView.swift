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
                }.frame(width: 65)
                .layoutPriority(0.2)
                VStack {
                    HStack {
                        Text(publicCode)
                            .bold()
                            .lineLimit(2)
                            .font(.subheadline)
                        Text(" til ")
                    }
                    Text(destinationName)
                        .bold()
                        .lineLimit(2)
                        .font(.headline)
                        .truncationMode(.middle)
                }.layoutPriority(0.8)
            }

            Divider().background(Color.red)
            ForEach(departureList.departures) { departure in
                HStack {
                    Text(departure.formatTime(departure.time))
                        .font(.body)
                        .foregroundColor(departure.isRealTime ? .yellow : .white)
                }
                Spacer()
                
            }
            departureList.departures.count == 0
            ? VStack{
                Text("Ingen avganger")
                }
            : nil
            Divider()
            HStack {
                Text("Avganger i")
                Text("sanntid").foregroundColor(.yellow)
                
            }
        }.navigationBarTitle("Avganger")
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
