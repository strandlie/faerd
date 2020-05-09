//
//  AppState.swift
//  BusTime WatchKit Extension
//
//  Created by Håkon Strandlie on 24/12/2019.
//  Copyright © 2019 Håkon Strandlie. All rights reserved.
//

import Foundation
import Combine
import WatchKit

final class AppState: ObservableObject {
    @Published var isFetching = false
    @Published var hasPremiumFavorites = StoreController.shared.getProductStatus(for: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
    @Published var hasLocationAccess = false
    
    static let shared = AppState()
}
