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
public class GFInApp: NSObject, ObservableObject {
    // MARK: - Initializaton
    /**
     Initialize InApp handling.
     - Parameter purchasables: A mapping from products in app store to internal consumables and non-consumables. The dictionary key is the product-identifier as defined in app store. The value is the list of consumables and non-consumables that are impacted by this product.
     */
    internal init(_ purchasables: [String: [Purchasable]]) {
        log()
        productToPurchasable = purchasables
        super.init()

        // Start listening
        delegater = Delegater(parent: self)
        SKPaymentQueue.default().add(delegater!)
        load()
    }

    deinit {
        log()
        SKPaymentQueue.default().remove(delegater!)
    }
    
    // MARK: - Public functions
    /// Did the store react and send some products back, yet?
    @Published public fileprivate(set) var available: Bool = false

    /// GUI should indicate to wait while purchase is ongoing and not deferred
    @Published public fileprivate(set) var purchasing: Bool = false

    /// Contains the latest error, if a purchase failed. Cleared, if a transaction finished succesfully.
    @Published public fileprivate(set) var error: Error?

    /**
     Request payment (player decided to buy). Use the product(s) variable from the (Non)Consumable.
     - Parameter product: The product to buy. This value should be taken from the chosens consumable or non-consumable.
     - Parameter quantity: Is the quantity, that the player given to buy. For non-consumables, this number is ignored. For consumables the quantity here is multiplied by the quantity, given in the consumable for the product. Eaxample: You offer a product, that for 10 Lasershots for only 0.99$. The player buys 2 of the. Then he pays 2x0.99$ and gets 10x2=20 Lasershots on the `Consumable.available`. This helps to create products for non-linear pricing, e.g. you can discount like: 1 piece costs 0.99$ and 5 pieces only 2.99$.
     */
    public func buy(product: SKProduct, quantity: Int) {
        log(product.productIdentifier, quantity)
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
    
    /**
     Clear error. This should be done, after error was shown to the player.
     */
    public func clearError() {error = nil}
    
    // MARK: - Internal handling

    /// Availability can differ by players age and country
    private var request: SKProductsRequest! // Needs to stay active

    /// Load all available products from store.
    private func load() {
        request = SKProductsRequest(productIdentifiers: Set(productToPurchasable.keys))
        request.delegate = delegater!
        request.start()
    }

    // MARK: - Configuration handling
    /**
     Used to map products in app store to consumables and non-consumables.
     */
    public enum Purchasable {
        /// Product affects consumables with quantity amount of units, e.g. product is to buy 20 coffee mugs, then "coffee mug" is the consumable and 20 the quantity
        case Consumable(id: String, quantity: Int)
        /// Non-Consumable affected by product.
        case NonConsumable(id: String)
        
        fileprivate func buy(isPrebook: Bool, quantity purchasedQuantity: Int = 1) {
            switch self {
            case let .Consumable(id: id, quantity: quantity):
                let consumable = GameFrame.coreData.getConsumable(id)
                
                if isPrebook {
                    consumable.prebook(quantity * purchasedQuantity)
                } else {
                    consumable.buy(quantity * purchasedQuantity)
                }
                
            case let .NonConsumable(id: id):
                let nonConsumable = GameFrame.coreData.getNonConsumable(id)
                
                if isPrebook {
                    nonConsumable.prebook()
                } else {
                    nonConsumable.unlock()
                }
            }
        }
        
        fileprivate func rollback() {
            switch self {
            case let .Consumable(id: id, quantity: _):
                let consumable = GameFrame.coreData.getConsumable(id)
                consumable.rollback()
                
            case let .NonConsumable(id: id):
                let nonConsumable = GameFrame.coreData.getNonConsumable(id)
                nonConsumable.rollback()
            }
        }
        
        fileprivate var isConsumable: Bool {
            switch self {
            case .Consumable(id: _, quantity: _):
                return true
                
            default:
                return false
            }
        }
    }
    
    // MARK: publicly available functions
    /**
     Get all products, related to consumables and non-consumables.
     
     The returned list contains each product only once, regardless how much cons/non-nos are impacted by a purchase.
     - Parameters:
        - consumableIds: List of id's of consumables
        - nonConsumableIds: List of id's of non-consumables
     - returns: An array of SKProducts, where a purchase would affect the given cons/non-cons. The list is sorted by product-identifier.
     */
    public func getProducts(consumableIds: [String], nonConsumableIds: [String]) -> [SKProduct] {
        log(consumableIds, nonConsumableIds)
        
        let products: Set<SKProduct> = Set()
            .union(consumableIds.flatMap {consumableToProducts[$0] ?? []})
            .union(nonConsumableIds.flatMap {nonConsumableToProducts[$0] ?? []})
        
        return products.sorted {$0.productIdentifier < $1.productIdentifier}
    }
    
    // MARK: Internals
    private let productToPurchasable: [String: [Purchasable]] /// ProductId -> purchasables
    private var consumableToProducts = [String: [SKProduct]]() /// Receieved products
    private var nonConsumableToProducts = [String: [SKProduct]]() /// Receieved products

    /**
     Called, when a product was received from the app store.
     */
    fileprivate func productReceived(_ product: SKProduct) {
        guard let purchasables = productToPurchasable[product.productIdentifier] else {
            log(product.productIdentifier, "not configured!")
            return
        }
        
        purchasables.forEach {
            switch $0 {
            case let .Consumable(id: id, quantity: _):
                var products = consumableToProducts.getAndAddIfNotExisting(key: id, closure: {_ in []})
                products.append(product)
                consumableToProducts[id] = products
            case let .NonConsumable(id: id):
                var products = nonConsumableToProducts.getAndAddIfNotExisting(key: id, closure: {_ in []})
                products.append(product)
                nonConsumableToProducts[id] = products
            }
        }
    }
    
    /**
     Called, when product was bought or prebooked.
     */
    fileprivate func productBought(_ productId: String, quantity: Int, isPrebook: Bool) {
        if let productToPurchasable = productToPurchasable[productId] {
            productToPurchasable.forEach {$0.buy(isPrebook: isPrebook, quantity: quantity)}
        } else {
            log(productId, "not received from store!")
        }
    }
    
    /**
     Called, when purchase failed
     */
    fileprivate func purchaseFailed(_ productId: String) {
        if let productToPurchasable = productToPurchasable[productId] {
            productToPurchasable.forEach {
                $0.rollback()
            }
        } else {
            log(productId, "not received from store!")
        }
    }
    
    /**
     Product belongs purely to a consumable. Can be bought with higher quantity.
     - returns: true, if product is solely related to consumables. False, if product is related a least one time to a non-consumable or is not configured at all.
     */
    func isPurelyConsumable(_ productId: String) -> Bool {
        guard let purchasables = productToPurchasable[productId] else {return false}
        
        return purchasables.allSatisfy {$0.isConsumable}
    }
}

fileprivate var delegater: Delegater? = nil

private class Delegater: NSObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    private var parent: GFInApp

    fileprivate init(parent: GFInApp) {
        log()
        self.parent = parent
    }
    
    internal func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        log(response.products.map({$0.productIdentifier}), response.invalidProductIdentifiers)
        
        for product in response.products {
            parent.productReceived(product)
        }
        if !response.products.isEmpty {DispatchQueue.main.async {self.parent.available.set()}}
        
        for invalidId in response.invalidProductIdentifiers {
            log(invalidId, "not available in store")
        }
    }

    // MARK: Handle payment events
    internal func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        log(transactions.count)
        for transaction in transactions {
            log("\(transaction.payment.quantity) x \(transaction.payment.productIdentifier) -> \(transaction.transactionState)")
            switch transaction.transactionState {
                
            // Call the appropriate custom method for the transaction state.
            case .purchasing:
                log("purchasing")
                // Keep paused and fingers crossed
                self.parent.purchasing.set()
                break
            case .deferred:
                log("deferred")
                // Purchase is reflected immediately and rolled back later, if purchase fails.
                parent.productBought(
                    transaction.payment.productIdentifier,
                    quantity: transaction.payment.quantity,
                    isPrebook: true)
                self.parent.purchasing.unset()
                break
            case .failed:
                log("failed", transaction.error)
                // Rollback if necessary
                parent.purchaseFailed(transaction.payment.productIdentifier)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.parent.error = transaction.error
                self.parent.purchasing.unset()
                break
            case .purchased:
                log("purchased")
                parent.productBought(
                    transaction.payment.productIdentifier,
                    quantity: transaction.payment.quantity,
                    isPrebook: false)
                SKPaymentQueue.default().finishTransaction(transaction)
                self.parent.error = nil
                self.parent.purchasing.unset()
                break
            case .restored:
                log("restored")
                SKPaymentQueue.default().finishTransaction(transaction)
                self.parent.error = nil
                self.parent.purchasing.unset()
                break
            // For debugging purposes.
            @unknown default:
                log("Unexpected transaction state \(transaction.transactionState)")
                self.parent.error = nil
                self.parent.purchasing.unset()
            }
        }
    }
}
