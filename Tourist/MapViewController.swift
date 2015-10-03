//
//  ViewController.swift
//  Tourist
//
//  Created by Алексей Шпирко on 06/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CoreData

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var locationManager: CLLocationManager!
    @IBOutlet weak var mapView: MKMapView!
    var coords:CLLocationCoordinate2D!
    var selectedPin: Pin?
    
    func createLocationManager () {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
    }
    
    func locationManager (manager:CLLocationManager!, didUpdateLocations locations:[AnyObject]!) {
        if let firstlocation = locations.first as? CLLocation {
            mapView.setCenterCoordinate(firstlocation.coordinate, animated: true)
            let adjustedRegion = mapView.regionThatFits(MKCoordinateRegionMakeWithDistance(firstlocation.coordinate, 1000, 1000))
            mapView.setRegion(adjustedRegion, animated: true)
            coords = firstlocation.coordinate
            locationManager.stopUpdatingLocation()
        }
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addRecognizer()
        
        createLocationManager()
        
        locationManager?.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        mapView.delegate = self
        
        fetchPins()
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func fetchPins() {
        
        let fetchRequest = NSFetchRequest(entityName: "Pin")
        
        if let fetchResults = CoreDataManager.sharedInstance.mainContex!.executeFetchRequest(fetchRequest, error: nil) as? [Pin] {
            
            placePins(fetchResults)
        }
    }
    
    func placePins(pins: [Pin]) {
        
        for pin in pins {
            
            var annotation =  MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(pin.latitude.doubleValue, pin.longitude.doubleValue)
            mapView.addAnnotation(annotation)
        }
    }

    func addRecognizer() {
        
        var recognizer = UILongPressGestureRecognizer(target: self, action: "handleLongPress:")
        recognizer.minimumPressDuration = 1
        mapView.addGestureRecognizer(recognizer)
    
    }
    
    func handleLongPress(recognizer:UILongPressGestureRecognizer) {
        
        if (recognizer.state != UIGestureRecognizerState.Began) {
            return
        }
        var touchPoint = recognizer.locationInView(mapView)
        var touchMapCoordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
        
        var annotation = MKPointAnnotation()
        
        
        annotation.coordinate = touchMapCoordinate
        mapView.addAnnotation(annotation)
        selectedPin = savePin(touchMapCoordinate)
        
    }
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier("pin") as? MKPinAnnotationView
        if (annotationView == nil && (annotation.isKindOfClass(MKUserLocation) == false)) {
            
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
            annotationView!.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
            annotationView!.pinColor = .Red
            annotationView!.draggable = true
            annotationView!.animatesDrop = true
        }
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        mapView.deselectAnnotation(view.annotation, animated: false)
        if selectedPin != nil {
          performSegueWithIdentifier("showPhotos", sender: nil)
        }
       
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    
        if (segue.identifier == "showPhotos") {
            
            let photosVC = segue.destinationViewController as! PhotosViewController
            photosVC.selectedPin = selectedPin
        }
    }
    
    
    func savePin(coordinates:CLLocationCoordinate2D) -> Pin {
        
        let pin = NSEntityDescription.insertNewObjectForEntityForName("Pin", inManagedObjectContext: CoreDataManager.sharedInstance.mainContex!) as! Pin
        pin.latitude = coordinates.latitude
        pin.longitude = coordinates.longitude
        
        var objId = pin.objectID
        CoreDataManager.sharedInstance.save()
        return pin
        
    }

}
