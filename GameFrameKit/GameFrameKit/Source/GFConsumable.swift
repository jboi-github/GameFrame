//
//  Consumable.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 21.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import Foundation
import CoreData
import StoreKit

public class GFConsumable: ObservableObject {
    internal var delegate: GFEntityConsumable {
           didSet(prev) {
               guard prev != delegate else {return}
               if let context = delegate.managedObjectContext {
                   context.delete(prev)
                   merge(prev: prev)
               }
           }
       }
     
    /// Currently available goods from bought, earned and consumed
    @Published private(set) var available: Int
    
    // Published var cannot be a calculated property, so need to trigger here
    private var earned: Int {didSet {available = earned + bought + prebooked - consumed}}
    private var bought: Int {didSet {available = earned + bought + prebooked - consumed}}
    private var prebooked: Int {didSet {available = earned + bought + prebooked - consumed}}
    private var consumed: Int {didSet {available = earned + bought + prebooked - consumed}}

    // The corresponding product to buy from, if available
    internal var products = [Int:SKProduct]() // Products available in store for this consumable, player, country, ...
 
    internal init(delegate: GFEntityConsumable) {
        self.delegate = delegate
        self.earned = Int(delegate.earned)
        self.bought = Int(delegate.bought)
        self.prebooked = Int(delegate.prebooked)
        self.consumed = Int(delegate.consumed)
        available = earned + bought + prebooked - consumed
    }
      
    // init from new instance
    internal convenience init(_ id: String, context: NSManagedObjectContext) {
        self.init(delegate: NSEntityDescription.insertNewObject(forEntityName: "GFConsumable", into: context) as! GFEntityConsumable)
        delegate.id = id
    }

    /// Earn (increment) consumable
    public func earn(_ earned: Int) {self.earned += earned}
      
     /// Buy (increment) consumable
     public func buy(_ bought: Int) {
        self.bought += bought
        if self.prebooked > 0 {self.prebooked -= bought}
    }
      
     /// Prebook, if purchase is deferred. Allow only once. (increment) consumable
     public func prebook(_ prebooked: Int) {
         guard self.prebooked == 0 else {return}
         self.prebooked += prebooked
     }
     
    /// Rollback any prebooking, if exists
    public func rollback() {self.prebooked = 0}

    /// Consume (decrement) consumable
    public func consume(_ consumed: Int) {self.consumed += consumed}
     
    internal func prepareForSave() {
        delegate.earned = Int64(earned)
        delegate.bought = Int64(bought)
        delegate.prebooked = Int64(prebooked)
        delegate.consumed = Int64(consumed)
    }
    
    internal func merge(prev: GFEntityConsumable) {
        earned = Int(max(delegate.earned, prev.earned))
        bought = Int(max(delegate.bought, prev.bought))
        prebooked = Int(max(delegate.prebooked, prev.prebooked))
        consumed = Int(max(delegate.consumed, prev.consumed))
    }
}
