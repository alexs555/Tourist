//
//  Photo.swift
//  
//
//  Created by Алексей Шпирко on 15/09/15.
//
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var server: String
    @NSManaged var secret: String
    @NSManaged var filename: String
    @NSManaged var stringUrl: String
    @NSManaged var farm: NSNumber
    @NSManaged var pin: Photo
    
    var url:NSURL {
        
        get {
             return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(filename)")!
        }
    }
    
    func setWithData(dictionary: [NSObject: AnyObject]) {
        
        id = dictionary["id"] as! String
        title = dictionary["title"] as! String
        server = dictionary["server"] as! String
        secret = dictionary["secret"] as! String
        farm = dictionary["farm"] as! Int
        filename = "\(id)_\(secret).jpg"
                
    }

}
