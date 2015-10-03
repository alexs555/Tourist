//
//  PhotosDataProvider.swift
//  Tourist
//
//  Created by Алексей Шпирко on 27/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import CoreData
import SwiftyJSON

//repository

class PhotosDataPovider {
    
    static func parse(json:AnyObject?, pin:Pin) -> Array<Photo> {
        
        var photosArray = Array<Photo>()
        
        
        if (json != nil) {
            
            let results = JSON(json!)["photos"]["photo"]
            
            if (results != nil) {
                
                for photo in results.array! {
                    
                    let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: CoreDataManager.sharedInstance.mainContex!) as! Photo
                    newPhoto.setWithData(photo)
                    
                    var error : NSError?
                    if let pin = CoreDataManager.sharedInstance.mainContex!.existingObjectWithID(pin.objectID, error: &error) as? Pin {
                        newPhoto.pin = pin
                    }
                
                    photosArray.append(newPhoto)
                
                }
                pin.photos = NSSet(array: photosArray)
            }
        }

        CoreDataManager.sharedInstance.save()
       // println("photos - \(photosArray)")
        return photosArray
        
    }
    
}
