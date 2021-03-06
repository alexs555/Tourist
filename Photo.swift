//
//  Photo.swift
//  
//
//  Created by Алексей Шпирко on 15/09/15.
//
//

import Foundation
import CoreData
import SwiftyJSON

@objc(Photo)
class Photo: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var title: String
    @NSManaged var server: String
    @NSManaged var secret: String
    @NSManaged var filename: String
    @NSManaged var farm: NSNumber
    @NSManaged var pin: Pin
    
    var url:NSURL {
        
        get {
          
             return NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(filename)")!
        }
    }
    
    func setWithData(dictionary: JSON) {
        
        id = dictionary["id"].stringValue
        title = dictionary["title"].stringValue
        server = dictionary["server"].stringValue
        secret = dictionary["secret"].stringValue
        farm = dictionary["farm"].intValue
        filename = "\(id)_\(secret).jpg"
        
    }
    
    override func prepareForDeletion() {
        super.prepareForDeletion()
        
        let path = ImagesStorage.getPathForFilename(filename)
        
        if (NSFileManager.defaultManager().isDeletableFileAtPath(path)) {
            NSFileManager.defaultManager().removeItemAtPath(path, error: nil)
        }
    }

}
