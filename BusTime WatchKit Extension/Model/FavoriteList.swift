//
//  FavoriteList.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 25/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

class FavoriteList: ObservableObject {
    
    @Published var favorites: [Favorite]
    
    init(favorites: [Favorite]) {
        self.favorites = favorites
    }
    
    init() {
        self.favorites = []
    }
}
