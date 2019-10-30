//
//  GFEntityConsumable+CoreDataProperties.swift
//  GameFrame
//
//  Created by Juergen Boiselle on 30.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//
//

import Foundation
import CoreData


extension GFEntityConsumable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GFEntityConsumable> {
        return NSFetchRequest<GFEntityConsumable>(entityName: "GFConsumable")
    }

    @NSManaged public var bought: Int64
    @NSManaged public var consumed: Int64
    @NSManaged public var earned: Int64
    @NSManaged public var id: String?
    @NSManaged public var prebooked: Int64

}
