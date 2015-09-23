//
//  Pin.swift
//  
//
//  Created by Алексей Шпирко on 15/09/15.
//
//

import Foundation
import CoreData

class Pin: NSManagedObject {

    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var photos: NSSet

}
