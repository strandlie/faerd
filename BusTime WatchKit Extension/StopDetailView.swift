//
//  StopDetailView.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 16/08/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct StopDetailView: View {
    let stop: BusStop
    let distance: String
    
    
    var body: some View {
        VStack {
            Text(stop.name)
                .bold()
                .font(.callout)
                .truncationMode(.middle)
            Text(distance)
                .bold()
            
            List(stop.lines.map({$0}), id: \.self) { line in
                HStack {
                    Text(String(line))
                        .bold()
                        .padding()
                    
                    Text("2 min")
                }
            }
        }
    .navigationBarTitle("Avganger")
    }
}

#if DEBUG
struct StopDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StopDetailView(stop: BusStop(id: "16010050", name: "Studentersamfundet 3", location: CLLocation(latitude: 63.4324, longitude: 10.4073)), distance: "104m")
    }
}
#endif
