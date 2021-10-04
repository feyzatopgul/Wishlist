//
//  List+CoreDataProperties.swift
//  Wishlist
//
//  Created by fyz on 7/4/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//
//

import Foundation
import CoreData


extension List {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<List> {
        return NSFetchRequest<List>(entityName: "List")
    }

    @NSManaged public var name: String?
    @NSManaged public var id: NSNumber

}
