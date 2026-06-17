//
//  DataController-StoreKit.swift
//  UltimatePortfolio
//
//  Created by Stefan on 16.06.26.
//

import Foundation
import StoreKit
import Combine

extension DataController {
    /// The product ID for our premium unlock
    static let unlockPremiumProductID = "com.stdehnbostel.UltimatePortfolio.premiumUnlock"
    
    /// loads and saved whether our premium unlock has been purchased
    var fullVersionUnlock: Bool {
        get {
            defaults.bool(forKey: "fullVersionUnlocked")
        }
        set {
            defaults.set(newValue, forKey: "fullVersionUnlocked")
        }
    }
    
    func monitorTransactions() async {
        // check for previous purchases
        for await entitlement in Transaction.currentEntitlements {
            if case let .verified(transaction) = entitlement {
                await finalize(transaction)
            }
        }
        
        // watch for future transactions coming in
        for await update in Transaction.updates {
            if let transaction = try? update.payloadValue {
                await finalize(transaction)
            }
        }
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        if case let .success(validation) = result {
            try await finalize(validation.payloadValue)
        }
    }
    
    @MainActor
    func finalize(_ transaction: Transaction) async {
        if transaction.productID == Self.unlockPremiumProductID {
            objectWillChange.send()
            fullVersionUnlock = transaction.revocationDate == nil
            await transaction.finish()
        }
    }
}
