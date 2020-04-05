//
//  StoreController.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 08/02/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation
import StoreKit

class StoreController: NSObject {
    static var shared = StoreController()
    
    /// Keeps track of all valid products (these products are available for sale in the App Store) and of all invalid product identifiers
    fileprivate var storeResponse = [Section]()
    
    fileprivate var availableProducts = [SKProduct]()
    
    fileprivate var invalidProductIdentifiers = [String]()
    
    
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
    
    func fetchProductInformation() {
        if StoreObserver.shared.isAuthorizedForPayments {
            let resourceFile = ProductIdentifiers()
            guard let identifiers = resourceFile.identifiers else {
                return
            }
            if !identifiers.isEmpty {
                startProductRequest(with: identifiers)
            }
        }
    }
    
    func startProductRequest(with identifiers: [String]) {
        let productIdentifiers = Set(identifiers)
        
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        productRequest.start()
    }
}

extension StoreController: SKProductsRequestDelegate {
    /// - Tag: ProductRequest
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        if !storeResponse.isEmpty {
            storeResponse.removeAll()
        }
        
        // products contains products whose identifiers have been recognized by the App Store. As such, they can be purchased
        if !response.products.isEmpty {
            availableProducts = response.products
            storeResponse.append(Section(type: .availableProducts, elements: availableProducts))
        }
        
        // invalidProductIdentifiers contains all product identifiers not recognized by the App Store
        if !response.invalidProductIdentifiers.isEmpty {
            invalidProductIdentifiers = response.invalidProductIdentifiers
            storeResponse.append(Section(type: .invalidProductIdentifiers, elements: invalidProductIdentifiers))
        }
        
        if !storeResponse.isEmpty {
            ProductList.shared.products = availableProducts.map { product in product.localizedTitle }
        }
        
        
    }
}
