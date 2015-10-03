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
    var photos: Array<Photo>?
    var imagesStore: ImagesStorage!
    var itemSize:CGSize!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var error:NSError?
        fetchedResultsController.performFetch(&error)
        
        photos = fetchedResultsController.fetchedObjects as? Array<Photo>
      //  println("objects \(photos)")
        collectionView.reloadData()
      
        
        imagesStore = ImagesStorage()
        configureMapView()
        loadData()
        
        let width = (view.bounds.size.width / 3) - 10
        itemSize = CGSizeMake(width, width)
        // Do any additional setup after loading the view.
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
    
        ApiClient.defaultClient.fetchPhotosForCoordinates(coords,pin: selectedPin!, page: 1, completionHandler: {
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
        collectionView.reloadData()
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
        println("photo - \(photo.url.absoluteString)")
        
        imagesStore.imageWithUrl(photo.url, filename: photo.filename, completion: { image in
            cell.setImage(image)
        })
        
        return cell
    }
}

extension PhotosViewController : UICollectionViewDelegate {
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
       /* selectedPhotos.addObject(photos![indexPath.row])
        selectedIndexPaths.addObject(indexPath)
        updateTollbarButton()*/
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        
       /* selectedPhotos.removeObject(photos![indexPath.row])
        selectedIndexPaths.removeObject(indexPath)
        updateTollbarButton()*/
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        return itemSize
    }
}
