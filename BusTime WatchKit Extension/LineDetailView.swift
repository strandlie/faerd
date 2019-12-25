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
    let stop: BusStop
    let distance: String
    
    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text(departureList.departures[0].publicCode)
                        .bold()
                        .lineLimit(2)
                        .font(.subheadline)
                    Text(" til ")
                }
                Text(departureList.departures[0].destinationName)
                .bold()
                .lineLimit(2)
                .font(.headline)
                .truncationMode(.middle)
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
            Divider()
            HStack {
                Text("Avganger i")
                Text("sanntid").foregroundColor(.yellow)
                
            }
        }.navigationBarTitle("Avganger for")
    }
}

struct LineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Spacer()
    }
}
