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
    
    /*
     Asynchronously save to UserDefaults, since it is slow on the Apple Watch
     */
    func setFavorites(_ favorites: [Favorite]) {
        DispatchQueue.main.async {
            let favoritesData = try? JSONEncoder().encode(favorites)
            guard let encodedFavorites = favoritesData else {
                fatalError("Unexpected error in encoding of favorites")
            }
            UserDefaults.standard.set(encodedFavorites, forKey: UserDefaultsKeys.favorites.rawValue)
        }
    }
    
    func addFavorite(_ favorite: Favorite) {
        DispatchQueue.main.async {
            var existingFavorites = self.getFavorites()
            existingFavorites.append(favorite)
            self.setFavorites(existingFavorites)
        }
        
    }
    
    func removeFavorite(_ favorite: Favorite) {
        DispatchQueue.main.async {
            var existingFavorites = self.getFavorites()
            existingFavorites.removeAll { existingFavorite in
                favorite == existingFavorite
            }
            self.setFavorites(existingFavorites)
        }
        
    }
}
