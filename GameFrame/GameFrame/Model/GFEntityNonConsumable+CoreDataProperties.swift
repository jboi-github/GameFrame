//
//  GFEntityNonConsumable+CoreDataProperties.swift
//  GameFrame
//
//  Created by Juergen Boiselle on 30.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//
//

import Foundation
import CoreData


extension GFEntityNonConsumable {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GFEntityNonConsumable> {
        return NSFetchRequest<GFEntityNonConsumable>(entityName: "GFNonConsumable")
    }

    @NSManaged public var id: String?
    @NSManaged public var isOpened: Bool
    @NSManaged public var prebooked: Bool

}
