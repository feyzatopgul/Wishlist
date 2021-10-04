//
//  List+CoreDataClass.swift
//  Wishlist
//
//  Created by fyz on 7/4/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//
//

import Foundation
import CoreData

@objc(List)
public class List: NSManagedObject {
    
    class func nextListID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "ListID") + 1
        userDefaults.set(currentID, forKey: "ListID")
        userDefaults.synchronize()
        return currentID
    }

}
