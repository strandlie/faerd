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
        VStack {
            HStack {
                Text(departureList.departures[0].publicCode).bold()
                    .lineLimit(2)
                    .font(.footnote)
                Text(" fra ")
                    .font(.footnote)
                Text(stop.name)
                    .bold()
                    .lineLimit(2)
                    .font(.footnote)
                    .truncationMode(.middle)
            }
            
            HStack {
                Text(distance)
                    .font(.footnote)
                ForEach(stop.types, id: \.self) { type in
                    Image(type.rawValue).colorInvert().colorMultiply(.red)
                }
            }
            ScrollView() {
                ForEach(departureList.departures) { departure in
                    HStack {
                        /*
                        ZStack(alignment: .leading) {
                            Text("123")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.publicCode)
                                .bold()
                                .font(.callout)
                        }*/
                        
                        ZStack(alignment: .leading) {
                            Text("111111111111111111")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.destinationName)
                                .font(.footnote)
                        }
                        ZStack(alignment: .trailing) {
                            Text("22:30")
                                .opacity(0)
                                .accessibility(hidden: true)
                            Text(departure.formatTime(departure.time))
                                .italic()
                                .font(.callout)
                                .foregroundColor(departure.isRealTime ? .yellow : .white)
                        }
                    }.lineLimit(3)
                }
                        
            }
        }
        
    }
}

struct LineDetailView_Previews: PreviewProvider {
    static var previews: some View {
        LineDetailView(departureList: DepartureList(), stop: BusStop(), distance: "183 m")
    }
}
