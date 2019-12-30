//
//  FavoriteLineButton.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 29/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct FavoriteLineButton: View {
    let destinationName: String
    let publicCode: String
    
    var body: some View {
        HStack {
            IconController.getIcon(for: Favorite.FavoriteType.departure.rawValue)
            
            VStack(alignment: .leading) {
                Text(destinationName)
                    .font(.headline)
                    .truncationMode(.tail)
                    .lineLimit(2)
            }
            Spacer()
        }
    }
}

struct LineButton_Previews: PreviewProvider {
    static let destinationName = "Tyholt"
    static let publicCode = "22"
    static var previews: some View {
        FavoriteLineButton(destinationName: destinationName, publicCode: publicCode)
    }
}
