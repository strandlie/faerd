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
        guard let existingFavorites = UserDefaults.standard.array(forKey: UserDefaultsKeys.favorites.rawValue) as? [Favorite] else {
            fatalError("Malformed favorites in UserDefaults")
        }
        return existingFavorites
    }
    
    func setFavorites(_ favorites: [Favorite]) {
        UserDefaults.standard.set(favorites, forKey: UserDefaultsKeys.favorites.rawValue)
    }
    
    func addFavorite(favorite: Favorite) {
        var existingFavorites = getFavorites()
        existingFavorites.append(favorite)        
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
}
