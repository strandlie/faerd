//
//  FavoritesController.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 26/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

class FavoritesController {
    static let shared = FavoritesController()
    
    func getFavorites() -> [Favorite] {
        guard let encodedFavorites = UserDefaults.standard.data(forKey: UserDefaultsKeys.favorites.rawValue) else {
            return []
        }
        guard let favorites = try? JSONDecoder().decode([Favorite].self, from: encodedFavorites) else {
            fatalError("Encoding error when decoding favorites from UserDefaults")
        }
        
        return favorites
    }
    
    func setFavorites(_ favorites: [Favorite]) {
        let favoritesData = try? JSONEncoder().encode(favorites)
        guard let encodedFavorites = favoritesData else {
            fatalError("Unexpected error in encoding of favorites")
        }
        UserDefaults.standard.set(encodedFavorites, forKey: UserDefaultsKeys.favorites.rawValue)
        
        
    }
    
    func addFavorite(_ favorite: Favorite) {
        var existingFavorites = getFavorites()
        existingFavorites.append(favorite)
        setFavorites(existingFavorites)
    }
    
    func removeFavorite(_ favorite: Favorite) {
        var existingFavorites = getFavorites()
        existingFavorites.removeAll { existingFavorite in
            favorite == existingFavorite
        }
        setFavorites(existingFavorites)
    }
    
    func increasePriorityOf(favorite: Favorite) {
        var favorites = getFavorites()
        let index = favorites.firstIndex(where: {$0 == favorite})
        if let index = index {
            if (index > 0) {
                favorites.swapAt(index, index - 1)
            }
        }
        setFavorites(favorites)
    }
    
    func decreasePriorityOf(favorite: Favorite) {
        var favorites = getFavorites()
        let index = favorites.firstIndex(where: {$0 == favorite})
        if let index = index {
            if (index < favorites.count - 1) {
                favorites.swapAt(index, index + 1)
            }
        }
        setFavorites(favorites)
    }
    
    func existsLocationFavorite(for stop: BusStop) -> Bool {
        let existingFavorites = getFavorites()
        for favorite in existingFavorites {
            if favorite.stop == stop && favorite.destinationName == nil {
                return true
            }
        }
        return false
    }
    
    func isFavorite(_ favorite: Favorite) -> Bool {
        let existingFavorites = getFavorites()
        for exisitingFavorite in existingFavorites {
            if favorite == exisitingFavorite {
                return true
            }
        }
        return false
    }
    
    func getLocationFavorite(for stop: BusStop) -> Favorite? {
        let existingFavorites = getFavorites()
        for existingFavorite in existingFavorites {
            if existingFavorite.stop == stop && existingFavorite.destinationName == nil {
                return existingFavorite
            }
        }
        return nil
    }
    
    func getLineFavorite(for stop: BusStop, destinationName: String, publicCode: String) -> Favorite? {
        let existingFavorites = getFavorites()
        for existingFavorite in existingFavorites {
            if existingFavorite.stop == stop
                && existingFavorite.destinationName == destinationName
                && existingFavorite.publicCode == publicCode {
                return existingFavorite
            }
        }
        return nil
    }
}
