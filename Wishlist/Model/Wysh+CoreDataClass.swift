//
//  Wysh+CoreDataClass.swift
//  Wishlist
//
//  Created by fyz on 7/4/18.
//  Copyright © 2018 Feyza Topgul. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Wysh)
public class Wysh: NSManagedObject {

    var hasPhoto: Bool {
        return photoImage != nil
    }
    
    var photoURL: URL {
        assert(imageId != nil, "No photo ID set")
        let filename = "Photo-\(imageId!).png"
        return applicationDocumentsDirectory.appendingPathComponent(filename)
    }
    
    var photoImage: UIImage? {
        return UIImage(contentsOfFile: photoURL.path)
    }
    
    class func nextPhotoID() -> Int {
        let userDefaults = UserDefaults.standard
        let currentID = userDefaults.integer(forKey: "PhotoID") + 1
        userDefaults.set(currentID, forKey: "PhotoID")
        userDefaults.synchronize()
        return currentID
    }
    
}
