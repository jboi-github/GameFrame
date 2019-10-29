//
//  GFCoreDataCloudKit.swift
//  DiggingDiamonds
//
//  Created by Juergen Boiselle on 28.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//

import CoreData
import SwiftUI

/**
 Synchronize objects with CoreData and, if player is logged in, iCloud. If the player is logged in, all objects are synchronized to iCloud and therefore available on all
 devices. The class controls when achievements, scores, consumables and non-consumables are loaded, saved and synchronized.
 The getter functions automatically create the corresponding instance and saves/synchronizes them.
 */
public class GFCoreDataCloudKit: NSObject {
    // MARK: - Initializaton
    internal override init() {
        log()

        // Create instance
        delegate = NSPersistentCloudKitContainer(name: "GameFrame")
        super.init()

        delegate.loadPersistentStores() {
            (storeDescription, error) in
            
            log(storeDescription)
            guard check(error) else {return}
            self.delegate.viewContext.automaticallyMergesChangesFromParent = true
        }

        // Fetch data and keep track of changes
        loadAll()
    }
    
    // MARK: - Public functions
    /**
     Get and eventually create an achievement with the given id. If the achievement exists in CoreData, the value is taken from there. If not, a new achievement with default values is created.
     - Parameter id: The `id` to get and find the achievement.
     - returns: The achievement as it was found in data or a newly created Default-Achievement
     */
    public func getAchievement(_ id: String) -> GFAchievement {
        log(id)
        return achievements.getAndAddIfNotExisting(key: id) {
            (id) -> GFAchievement in
            GFAchievement(id, context: delegate.viewContext)
        }
    }
    
    /**
     Get and eventually create a score with the given id. If the score exists in CoreData, the value is taken from there.
     If not, a new score with default values is created.
     - Parameter id: The `id` to get and find the score.
     - returns: The score as it was found in data or a newly created Default-Score
     */
    public func getScore(_ id: String) -> GFScore {
        log(id)
        return scores.getAndAddIfNotExisting(key: id) {
            (id) -> GFScore in
            return GFScore(id, context: delegate.viewContext)
        }
    }
    
    /**
     Get and eventually create a consumable with the given id. If the consumable exists in CoreData, the value is taken from there.
     If not, a new consumable with default values is created.
     - Parameter id: The `id` to get and find the score.
     - returns: The score as it was found in data or a newly created Default-Score
     */
    public func getNonConsumable(_ id: String) -> GFNonConsumable {
        log(id)
        return nonConsumables.getAndAddIfNotExisting(key: id) {
            (id) -> GFNonConsumable in
            GFNonConsumable(id, context: delegate.viewContext)
        }
    }
    
    /**
     Get and eventually create an score with the given id. If the score exists in CoreData, the value is taken from there.
     If not, a new score with default values is created.
     - Parameter id: The `id` to get and find the score.
     - returns: The score as it was found in data or a newly created Default-Score
     */
    public func getConsumable(_ id: String) -> GFConsumable {
        log(id)
        return consumables.getAndAddIfNotExisting(key: id) {
            (id) -> GFConsumable in
            GFConsumable(id, context: delegate.viewContext)
        }
    }

    // MARK: - Internal handling
    private let delegate: NSPersistentCloudKitContainer

    /// Save context.
    internal func save() {
        // Call prepare save on all elements
        achievements.forEach { (key: String, value: GFAchievement) in value.prepareForSave()}
        scores.forEach { (key: String, value: GFScore) in value.prepareForSave()}
        nonConsumables.forEach { (key: String, value: GFNonConsumable) in value.prepareForSave()}
        consumables.forEach { (key: String, value: GFConsumable) in value.prepareForSave()}

        // Save the context
        guard delegate.viewContext.hasChanges else {return}
        do {
            try delegate.viewContext.save()
        } catch {
            guard check(error) else {return}
        }
    }

   /// Load context.
   fileprivate func loadAll() {
       load(request: GFEntityScore.fetchRequest()) {
           (element) in

           guard let score = element as? GFEntityScore else {return}
           guard let id = score.id else {return}
           scores.getAndAddIfNotExisting(key: id, closure: {_ in GFScore(delegate: score)}).delegate = score
       }
       load(request: GFEntityAchievement.fetchRequest()) {
           (element) in
           
           guard let achievement = element as? GFEntityAchievement else {return}
           guard let id = achievement.id else {return}
           achievements.getAndAddIfNotExisting(key: id, closure: {_ in GFAchievement(delegate: achievement)}).delegate = achievement
       }
       load(request: GFEntityConsumable.fetchRequest()) {
           (element) in
           
           guard let consumable = element as? GFEntityConsumable else {return}
           guard let id = consumable.id else {return}
           consumables.getAndAddIfNotExisting(key: id, closure: {_ in GFConsumable(delegate: consumable)}).delegate = consumable
       }
       load(request: GFEntityNonConsumable.fetchRequest()) {
           (element) in
           
           guard let nonConsumable = element as? GFEntityNonConsumable else {return}
           guard let id = nonConsumable.id else {return}
           nonConsumables.getAndAddIfNotExisting(key: id, closure: {_ in GFNonConsumable(delegate: nonConsumable)}).delegate = nonConsumable
       }
   }

   private func load(request: NSFetchRequest<NSFetchRequestResult>, map: (NSFetchRequestResult) -> Void) {
        do {
           request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)] // It simply needs one
           let controller = NSFetchedResultsController(fetchRequest: request, managedObjectContext: delegate.viewContext, sectionNameKeyPath: nil, cacheName: nil)
           controller.delegate = incorporateChanges
           try controller.performFetch()
           if let fetched = controller.fetchedObjects {
               fetched.forEach {element in map(element)}
           }
       } catch {
        guard check(error) else {return}
       }
   }
   
   private let incorporateChanges = IncorporateChanges()
}

fileprivate class IncorporateChanges: NSObject, NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        log()
        GameFrame.instance.coreDataImpl.loadAll()
    }
}
