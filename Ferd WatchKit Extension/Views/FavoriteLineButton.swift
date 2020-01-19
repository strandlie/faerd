//
//  FavoriteLineButton.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 29/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import SwiftUI

struct FavoriteLineButton: View {
    let originName: String
    let publicCode: String
    
    var body: some View {
        HStack {
            IconController.getIcon(for: Favorite.FavoriteType.departure.rawValue)
            
            HStack {
                
                Text(originName)
                    .font(.headline)
                    .truncationMode(.tail)
                    .lineLimit(2)
                Spacer()
                Text(publicCode)
            }
            Spacer()
        }
    }
}

struct LineButton_Previews: PreviewProvider {
    static let originName = "Tyholt"
    static let publicCode = "22"
    static var previews: some View {
        FavoriteLineButton(originName: originName, publicCode: publicCode)
    }
}
