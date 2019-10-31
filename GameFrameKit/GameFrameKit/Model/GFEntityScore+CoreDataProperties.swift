//
//  GFEntityScore+CoreDataProperties.swift
//  GameFrame
//
//  Created by Juergen Boiselle on 30.10.19.
//  Copyright © 2019 Juergen Boiselle. All rights reserved.
//
//

import Foundation
import CoreData


extension GFEntityScore {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GFEntityScore> {
        return NSFetchRequest<GFEntityScore>(entityName: "GFScore")
    }

    @NSManaged public var current: Int64
    @NSManaged public var highest: Int64
    @NSManaged public var id: String?

}
