//
//  GFEntityAchievement+CoreDataProperties.swift
//  GameFrame
//
//  Created by Juergen Boiselle on 29.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//
//

import Foundation
import CoreData


extension GFEntityAchievement {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GFEntityAchievement> {
        return NSFetchRequest<GFEntityAchievement>(entityName: "GFAchievement")
    }

    @NSManaged public var current: Double
    @NSManaged public var highest: Double
    @NSManaged public var id: String?

}
