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
    
    static func parse(json:AnyObject?)->Array<Photo> {
        
        var photosArray = Array<Photo>()
        
        let workerContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        workerContext.parentContext = CoreDataManager.sharedInstance.mainContex
        
        if (json != nil) {
            
            let results = JSON(json!)["photos"]["photo"]
            
            if (results != nil) {
                
                for photo in results.array! {
                    
                    let newPhoto = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: workerContext) as! Photo
                    newPhoto.setWithData(photo)
                    photosArray.append(newPhoto)
                }
            }
        }

        self.save(workerContext)
        println("photos - \(photosArray)")
        return photosArray
        
    }
    
     static func save(context: NSManagedObjectContext) {
        
        var error: NSError?
        if (!context.save(&error)) {
            println("Unresolved error in saving main context\(error)")
        } else {
            CoreDataManager.sharedInstance.save()
        }
    }
}
