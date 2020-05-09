//
//  StoreObserver.swift
//  Ferd WatchKit Extension
//
//  Created by Håkon Strandlie on 15/02/2020.
//  Copyright © 2020 Håkon Strandlie. All rights reserved.
//

import Foundation
import StoreKit

class StoreObserver: NSObject, SKPaymentTransactionObserver {
    
    static let shared = StoreObserver()
    
    var isAuthorizedForPayments: Bool {
        return SKPaymentQueue.canMakePayments()
    }

    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            switch transaction.transactionState {
            case .purchased:
                complete(transaction: transaction)
                break
            case .failed:
                fail(transaction: transaction)
                break
            case .restored:
                restore(transaction: transaction)
                break
            case .deferred:
                break
            case .purchasing:
                break
            @unknown default:
                fatalError("Unknown SKpayment state")
               
            }
        }
    }
       
    private func complete(transaction: SKPaymentTransaction) {
        StoreController.shared.setProductStatus(true, for: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
        AppState.shared.hasPremiumFavorites = StoreController.shared.getProductStatus(for: UserDefaultsKeys.premiumFavoritesStatus.rawValue)
        SKPaymentQueue.default().finishTransaction(transaction)
    }
       
    private func restore(transaction: SKPaymentTransaction) {
        complete(transaction: transaction)
    }
       
    private func fail(transaction: SKPaymentTransaction) {
        if let transactionError = transaction.error as NSError?, let localizedDescription = transaction.error?.localizedDescription, transactionError.code != SKErrorCode.paymentCancelled.rawValue {
            print("Transaction error: \(localizedDescription)")
        }
        SKPaymentQueue.default().finishTransaction(transaction)
    }
}
