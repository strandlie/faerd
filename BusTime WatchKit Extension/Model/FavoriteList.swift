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
    
    init(_ favorites: [Favorite]) {
        self.favorites = favorites
    }
    
    init() {
        self.favorites = FavoritesController.shared.getFavorites()
    }
    
    func existsLocationFavorite(for stop: BusStop) -> Bool {
        return FavoritesController.shared.existsLocationFavorite(for: stop)
    }
    
    func existsLineFavorite(for stop: BusStop, destinationName: String, publicCode: String) -> Bool {
        let existingFavorite = getLineFavorite(for: stop, destinationName: destinationName, publicCode: publicCode)
        guard let favorite = existingFavorite else {
            return false
        }
        return favorite.destinationName == destinationName && favorite.publicCode == publicCode
    }
    
    func getLocationFavorite(for stop: BusStop) -> Favorite? {
        return FavoritesController.shared.getLocationFavorite(for: stop)
    }
    
    func getLineFavorite(for stop: BusStop, destinationName: String, publicCode: String) -> Favorite? {
        return FavoritesController.shared.getLineFavorite(for: stop, destinationName: destinationName, publicCode: publicCode)
    }
    
    
    func append(_ favorite: Favorite) {
        FavoritesController.shared.addFavorite(favorite)
        self.favorites.append(favorite)
    }
    
    func remove(_ favorite: Favorite) {
        FavoritesController.shared.removeFavorite(favorite)
        self.favorites.removeAll { existingFavorite in
            existingFavorite == favorite
        }
    }
}
