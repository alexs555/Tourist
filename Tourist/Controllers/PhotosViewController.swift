//
//  PhotosViewController.swift
//  Tourist
//
//  Created by Алексей Шпирко on 30/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import CoreData

class PhotosViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectedPin: Pin?
    var photos : Array<Photo>?
    var imagesStore: ImagesStorage!
    var itemSize:CGSize!
    var currentPage = 1
    var selectedPhotos = NSMutableArray()
    var selectedIndexPaths = NSMutableArray()
    @IBOutlet weak var bottomBar: UIButton!
    
    
    @IBAction func bottomButtonPressed(sender: UIButton) {
        
        if (sender.titleLabel?.text == "New Collection") {
            ++currentPage
            loadData()
        } else {
            
         
            collectionView.performBatchUpdates( {
                
                for photo in self.selectedPhotos {
                    CoreDataManager.sharedInstance.mainContex!.deleteObject(photo as! NSManagedObject)
                }
                
                CoreDataManager.sharedInstance.save()
                self.collectionView.deleteItemsAtIndexPaths(self.selectedIndexPaths as [AnyObject])
                
                
                }, completion: nil)
            
            
            selectedPhotos.removeAllObjects()
            selectedIndexPaths.removeAllObjects()
            
            updateButton()
            
        }
      
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var error:NSError?
        fetchedResultsController.performFetch(&error)
        
        photos = fetchedResultsController.fetchedObjects as? Array<Photo>
    
        collectionView.allowsMultipleSelection = true
        
        imagesStore = ImagesStorage()
        configureMapView()
        
        if (selectedPin?.photos.count == 0) {
         loadData()
        }
        
        let width = (view.bounds.size.width / 3) - 10
        itemSize = CGSizeMake(width, width)
    }

    func configureMapView() {
        
        let coordinate = CLLocationCoordinate2DMake(selectedPin!.latitude.doubleValue, selectedPin!.longitude.doubleValue)
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        
        mapView.addAnnotation(annotation)
        mapView.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.07, 0.07)), animated: false)
    }
   
    func loadData() {
        
        var coords = CLLocationCoordinate2DMake(selectedPin!.latitude.doubleValue, selectedPin!.longitude.doubleValue)
    
        ApiClient.defaultClient.fetchPhotosForPin(selectedPin!, page: currentPage, completionHandler: {
            newPhotos, error in
            
            self.collectionView.reloadData()
            
        })
  
        
    }

    lazy var fetchedResultsController: NSFetchedResultsController = {
        
        var photosRequest = NSFetchRequest(entityName: "Photo")
        
        photosRequest.predicate = self.createPredicate()
        
        let primarySortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        photosRequest.sortDescriptors = [primarySortDescriptor]
        
        let frc = NSFetchedResultsController(
            fetchRequest: photosRequest,
            managedObjectContext: CoreDataManager.sharedInstance.mainContex!,
            sectionNameKeyPath: nil,
            cacheName: nil)
        
        frc.delegate = self
        
        return frc
        }()
    
    func createPredicate() -> NSPredicate? {
        
        if let pin = selectedPin {
           return NSPredicate(format: "pin.latitude = %@ AND pin.longitude = %@", selectedPin!.latitude, selectedPin!.longitude)
        }
        return nil
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        photos = controller.fetchedObjects as? Array<Photo>
        collectionView.reloadData()
    }
    
    func updateButton() {
        
        if selectedPhotos.count == 0 {
            
            bottomBar.setTitle("New Collection", forState: UIControlState.Normal)
        }
        else {
            bottomBar.setTitle("Remove Selected Pictures", forState: UIControlState.Normal)
        }
    }
    

}

extension PhotosViewController : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            let currentSection: AnyObject = sections[section]
            return currentSection.numberOfObjects
        }
        return 0
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as! CollectionCell
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo  //photos![indexPath.item]
        
        imagesStore.imageWithUrl(photo.url, filename: photo.filename, completion: { image in
            cell.setImage(image)
        })
        
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let photo = fetchedResultsController.objectAtIndexPath(indexPath) as! Photo
        selectedPhotos.addObject(photo)
        selectedIndexPaths.addObject(indexPath)
        updateButton()
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
        selectedPhotos.removeObject(fetchedResultsController.objectAtIndexPath(indexPath))
        selectedIndexPaths.removeObject(indexPath)
        updateButton()

    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return itemSize
    }
}
