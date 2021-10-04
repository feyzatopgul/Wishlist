//
//  Wysh+CoreDataProperties.swift
//  Wishlist
//
//  Created by fyz on 7/4/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//
//

import Foundation
import CoreData


extension Wysh {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Wysh> {
        return NSFetchRequest<Wysh>(entityName: "Wysh")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: NSNumber?
    @NSManaged public var store: String?
    @NSManaged public var notes: String?
    @NSManaged public var imageId: NSNumber?
    @NSManaged public var url: String?
    @NSManaged public var listId: NSNumber

}
