//
//  CoreDataManager.swift
//  Tourist
//
//  Created by Алексей Шпирко on 10/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import CoreData


class CoreDataManager {
    
    static let sharedInstance = CoreDataManager()
    
    
    func save() {
        
        if (!self.privateContext!.hasChanges && !self.mainContex!.hasChanges) {
            return
        }
        
        CoreDataManager.sharedInstance.mainContex?.performBlockAndWait( {
            
          var error: NSError?
            if (!self.mainContex!.save(&error)) {
              println("Unresolved error in saving main context\(error)")
            }
            
            self.privateContext?.performBlock({
                
                var error: NSError?
                if (!self.privateContext!.save(&error)) {
                    println("Unresolved error in saving private context\(error)")
                }
                
            })
            
        })
    }
    
    
    lazy var privateContext: NSManagedObjectContext? = {
        
         var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
         context.persistentStoreCoordinator = self.storeCoordinator
         return context
        
    }()
    
    //main context - all operations ui main thread
    lazy var mainContex: NSManagedObjectContext? = {
        
          var context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
          context.parentContext = self.privateContext
          return context
        
    }()
   
    lazy var managedObjectContext: NSManagedObjectContext? = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        let coordinator = self.storeCoordinator
        if coordinator == nil {
            return nil
        }
        var managedObjectContext = NSManagedObjectContext()
        managedObjectContext.persistentStoreCoordinator = coordinator
        return managedObjectContext
        }()
    
    //managed model
    lazy var managedModel: NSManagedObjectModel = {
    
        let path = NSBundle.mainBundle().pathForResource("Tourist", ofType:"momd")
        let momdUrl = NSURL.fileURLWithPath(path!)
        var localModel = NSManagedObjectModel(contentsOfURL: momdUrl!)
        return localModel!
    }()
    
    //Store coordinator
    lazy var storeCoordinator: NSPersistentStoreCoordinator? = {
        
        let storeURL = self.applicationDocumentsDirectory.URLByAppendingPathComponent("Tourist.sqlite")
        
        var coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel:self.managedModel)
            
        func addStore() -> NSError? {
            var result: NSError? = nil
            if coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: storeURL, options: nil, error: &result) == nil{
                println("Create persistent store error occurred: \(result?.userInfo)")
            }
            return result
        }
        
        var error = addStore()
    
        if  error != nil {
            println("Store scheme error. Will remove store and try again. TODO: add scheme migration.")
            NSFileManager.defaultManager().removeItemAtURL(storeURL, error: nil)
            error = addStore()
            
            if (error != nil) {
                println("Unresolved critical error with persistent store: \(error?.userInfo)")
                abort()
            }
        }
        return coordinator
    }()
    
    // Returns the URL to the application's Documents directory.
    lazy var applicationDocumentsDirectory: NSURL = {
        // The directory the application uses to store the Core Data store file. This code uses a directory named "com.shpirko.alex.Tourist" in the application's documents Application Support directory.
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count-1] as! NSURL
    }()
}
