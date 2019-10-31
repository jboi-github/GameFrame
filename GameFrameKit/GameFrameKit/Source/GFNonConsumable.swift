//
//  NonConsumable.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import StoreKit

public class GFNonConsumable: ObservableObject {
    internal var delegate: GFEntityNonConsumable {
           didSet(prev) {
               guard prev != delegate else {return}
               if let context = delegate.managedObjectContext {
                   context.delete(prev)
                   merge(prev: prev)
               }
           }
       }
    
    /// Current score
    @Published private(set) var isOpened: Bool
    private var prebooked: Bool // if true, the unlock is only prebooked and needs confirmation
    
    // The corresponding product to buy from, if available
    internal var product: SKProduct?

    internal init(delegate: GFEntityNonConsumable) {
        self.delegate = delegate
        self.isOpened = delegate.isOpened
        self.prebooked = delegate.prebooked
    }
      
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "GFNonConsumable", into: context) as! GFEntityNonConsumable)
        delegate.id = id
    }

    /// Earn (increment) some score
    public func unlock() {
        isOpened = true
        prebooked = false
    }
     
    /// Prebook, if purchase is deferred.
    public func prebook() {
        isOpened = true
        prebooked = true
    }
     
    /// Rollback any prebooking if exists
    public func rollback() {
        guard prebooked else {return}
        isOpened = false
        prebooked = false // Open for another try
    }

    internal func prepareForSave() {
        delegate.isOpened = isOpened
        delegate.prebooked = prebooked
    }
    
    internal func merge(prev: GFEntityNonConsumable) {
        isOpened = (delegate.isOpened || prev.isOpened)
        prebooked = (delegate.prebooked || prev.prebooked)
    }
}
