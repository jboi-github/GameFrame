//
//  GFInApp.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import StoreKit

/**
 Handling of in app purchases and related events. Consumables and NonConsumables are purchasable product, if they have a corresponding product configured in the store.
 - For NonConsumables the productId in store must match exactly the id of the consumable
 - For Cosnumables, you can have one or more products per consumable, with different base quantities. To configure this, see the `init()` function and the corresponding parameter.
 */
public class GFInApp: NSObject {
    // MARK: - Initializaton
    
    /**
     Initialize InApp handling.
     - Parameter consumableConfig: A dictionary of consumables that are backed by one or more products in the store. Each consumable is given by its id and associated by an array of tuples containing the products id as defined in the store and the quantity of consumable, that the product represents.
     Example: Say, you have one consumable "bullets" and two products with the ids "bullets10" and "bullets20". You can configure this with:
     `GFInApp(["bullets10" : ("bullets", 10), "bullets20" : ("bullets", 20)])`
     */
    internal init(_ consumablesConfig: [String: (String, Int)]) {
        log()
        super.init()
        delegater = Delegater(parent: self, consumablesConfig: consumablesConfig)
        delegater!.consumablesConfig = consumablesConfig

        // Start listening
        SKPaymentQueue.default().add(delegater!)
        load()
    }
    
    deinit {
        log()
        SKPaymentQueue.default().remove(delegater!)
    }
    
    // MARK: - Public functions
    /**
     Return consumables with one of the given `ids` and at least one available product in store and loaded.
     `Consumable.products` contains the store products and is garuanteed to have at least one entry.
     - Parameter ids: An array of all id's of the consumables to consider.
     - returns: An Array of NonConsumables where the products are available. The array is sorted in the same order, as `ids` were given.
     */
    public func getConsumables(ids: [String]) -> [GFConsumable] {
        log()
        var cs = [GFConsumable]()
        for id in ids {
            guard let consumable = consumables[id] else {continue}
            guard !consumable.products.isEmpty else {continue}
            
            cs.append(consumable)
        }
        return cs
    }
    
    /**
     Return non-consumables with one of the given `ids` and an available product in store and loaded.
     `NonConsumable.product` contains the store product and is garuanteed to have an entry.
     - Parameter ids: An array of all id's of the non-consumables to consider.
     - returns: An Array of NonConsumables where the product is available. The array is sorted in the same order, as `ids` were given.
     */
    public func getNonConsumables(ids: [String]) -> [GFNonConsumable] {
        log()
        var cs = [GFNonConsumable]()
        for id in ids {
            guard let nonConsumable = nonConsumables[id] else {continue}
            guard nonConsumable.product != nil else {continue}
            
            cs.append(nonConsumable)
        }
        return cs
    }
    
    /**
     Request payment (player decided to buy). Use the product(s) variable from the (Non)Consumable.
     - Parameter product: The product to buy. This value should be taken from the chosens consumable or non-consumable.
     - Parameter quantity: Is the quantity, that the player given to buy. For non-consumables, this number is ignored. For consumables the quantity here is multiplied by the quantity, given in the consumable for the product. Eaxample: You offer a product, that for 10 Lasershots for only 0.99$. The player buys 2 of the. Then he pays 2x0.99$ and gets 10x2=20 Lasershots on the `Consumable.available`. This helps to create products for non-linear pricing, e.g. you can discount like: 1 piece costs 0.99$ and 5 pieces only 2.99$.
     */
    public func buy(product: SKProduct, quantity: Int) {
        log()
        let payment = SKMutablePayment(product: product)
        payment.quantity = quantity
        
        SKPaymentQueue.default().add(payment)
    }
    
    /**
     Request to restore transactions for non-consumable products.
     Put this as action to a Button in Settings and Store Views.
    */
    public func restore() {
        log()
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    // MARK: - Internal handling

    /// Availability can differ by players age and country
    private var request: SKProductsRequest! // Needs to stay active

    /// Load all available products from store.
    private func load() {
        // Get all product Ids
        let ids = Set(nonConsumables.keys).union(delegater!.consumablesConfig.keys)
        
        // Request from store
        request = SKProductsRequest(productIdentifiers: ids)
        request.delegate = delegater!
        request.start()
    }
}

fileprivate var delegater: Delegater? = nil

private class Delegater: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    private var parent: GFInApp
    
    /// Dictionary of product-Ids -> Consumable-Id and base quantity
    fileprivate var consumablesConfig: [String: (consumableId: String, baseQuantity: Int)]

    fileprivate init(parent: GFInApp, consumablesConfig: [String: (consumableId: String, baseQuantity: Int)]) {
        log()
        self.parent = parent
        self.consumablesConfig = consumablesConfig
    }
    
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        log()
        for product in response.products {
            if let (consumable, baseQuantity) = readConfigFor(product.productIdentifier) {
                consumable.products[baseQuantity] = product
            } else if let nonConsumable = nonConsumables[product.productIdentifier] {
                nonConsumable.product = product
            }
        }
        
        for invalidId in response.invalidProductIdentifiers {
            log("Not available: \(invalidId)")
        }
    }

    // MARK: Handle payment events
    internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        log()
        for transaction in transactions {
            log("\(transaction.payment.quantity) x \(transaction.payment.productIdentifier) -> \(transaction.transactionState)")
            switch transaction.transactionState {
                
            // Call the appropriate custom method for the transaction state.
            case .purchasing:
                log("purchasing")
                // Keep paused and fingers crossed
                break
            case .deferred:
                log("deferred")
                // Purchase is reflected immediately and rolled back later, if purchase failed.
                if let (consumable, baseQuantity) = readConfigFor(transaction.payment.productIdentifier) {
                    consumable.prebook(transaction.payment.quantity * baseQuantity)
                } else if let nonConsumable = nonConsumables[transaction.payment.productIdentifier] {
                    nonConsumable.prebook()
                } else {
                    log("Unknown product! \(transaction.payment)")
                }
                break
            case .failed:
                log("failed")
                // Rollback if necessary
                if let (consumable, _) = readConfigFor(transaction.payment.productIdentifier) {
                    consumable.rollback()
                } else if let nonConsumable = nonConsumables[transaction.payment.productIdentifier] {
                    nonConsumable.rollback()
                } else {
                    log("Unknown product! \(transaction.payment)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .purchased:
                log("purchased")
                // Find right object for product
                if let (consumable, baseQuantity) = readConfigFor(transaction.payment.productIdentifier) {
                    consumable.buy(transaction.payment.quantity * baseQuantity)
                } else if let nonConsumable = nonConsumables[transaction.payment.productIdentifier] {
                    nonConsumable.unlock()
                } else {
                    log("Unknown product! \(transaction.payment)")
                }
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            case .restored:
                log("restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                break
            // For debugging purposes.
            @unknown default:
                log("Unexpected transaction state \(transaction.transactionState)")
            }
        }
    }
    
    private func readConfigFor(_ productId: String) -> (consumable: GFConsumable, baseQuantity: Int)? {
        if let (consumableId, baseQuantity) = consumablesConfig[productId],
            let consumable = consumables[consumableId] {
            
            return (consumable, baseQuantity)
        }
        return nil
    }
}
