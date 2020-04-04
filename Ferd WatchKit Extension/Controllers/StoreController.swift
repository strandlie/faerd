//
//  StoreController.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 08/02/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation

class StoreController {
    static var shared = StoreController()
    
    func getPremiumFavoritesStatus() -> Bool {
        return UserDefaults.standard.bool(forKey: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
        
    }
    
    func setPremiumFavoritesStatus(_ status: Bool) {
        UserDefaults.standard.set(status, forKey: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
    }
    
    func userWantsToBuyPremiumFavorites() {
        // ....
        setPremiumFavoritesStatus(true)
        AppState.shared.hasPremiumFavorites = getPremiumFavoritesStatus()
    }
}
