//
//  FavoriteList.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 25/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation

class FavoriteList: ObservableObject {
    
    static let FreeFavoriteLimit = 2
    
    @Published var favorites: [Favorite] {
        didSet {
            canAddMoreFavorites = FavoriteList.calculateAddStatus(for: favorites)
        }
    }
    @Published var canAddMoreFavorites: Bool
    
    init(_ favorites: [Favorite]) {
        self.favorites = favorites
        self.canAddMoreFavorites = FavoriteList.calculateAddStatus(for: favorites)
    }
    
    init() {
        let favorites = FavoritesController.shared.getFavorites()
        self.canAddMoreFavorites = FavoriteList.calculateAddStatus(for: favorites)
        self.favorites = favorites
    }
    
    var count: Int {
        get {
            return self.favorites.count
        }
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
        if canAddMoreFavorites {
            self.favorites.append(favorite)
            FavoritesController.shared.addFavorite(favorite)
        } else {
            fatalError("Tried to append a new favorite when does not have premium status. Should never happen")
        }
        
    }
    
    func remove(_ favorite: Favorite) {
        self.favorites.removeAll { existingFavorite in
            existingFavorite == favorite
        }
        FavoritesController.shared.removeFavorite(favorite)
    }
    
    private static func calculateAddStatus(for favorites: [Favorite]) -> Bool {
        return favorites.count < FavoriteList.FreeFavoriteLimit || AppState.shared.hasPremiumFavorites
    }
    
    
}
