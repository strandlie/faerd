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
        for favorite in favorites {
            if favorite.stop == stop && favorite.destinationName == nil {
                return true
            }
        }
        return false
    }
    
    func existsLineFavorite(for stop: BusStop, destinationName: String, publicCode: String) -> Bool {
        let existingFavorite = getLineFavorite(for: stop, destinationName: destinationName, publicCode: publicCode)
        guard let favorite = existingFavorite else {
            return false
        }
        return favorite.destinationName == destinationName && favorite.publicCode == publicCode
    }
    
    func getLocationFavorite(for stop: BusStop) -> Favorite? {
        for existingFavorite in favorites {
            if existingFavorite.stop == stop && existingFavorite.destinationName == nil {
                return existingFavorite
            }
        }
        return nil
    }
    
    func getLineFavorite(for stop: BusStop, destinationName: String, publicCode: String) -> Favorite? {
        for existingFavorite in favorites {
            if existingFavorite.stop == stop
                && existingFavorite.destinationName == destinationName
                && existingFavorite.publicCode == publicCode {
                return existingFavorite
            }
        }
        return nil
    }
    
    
    func append(_ favorite: Favorite) {
        self.favorites.append(favorite)
        FavoritesController.shared.addFavorite(favorite)
    }
    
    func remove(_ favorite: Favorite) {
        self.favorites.removeAll { existingFavorite in
            existingFavorite == favorite
        }
        FavoritesController.shared.removeFavorite(favorite)
    }
}
