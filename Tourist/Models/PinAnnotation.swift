//
//  PinAnnotation.swift
//  Tourist
//
//  Created by Алексей Шпирко on 04/10/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import MapKit

class PinAnnotation: NSObject, MKAnnotation {
   
    /*var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(pin.latitude.doubleValue, pin.longitude.doubleValue)
        }
        set {
            pin.latitude = newValue.latitude
            pin.longitude = newValue.longitude
        }
    }*/
    init (coordinate:CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    private var _pin: Pin? = nil
    var pin:Pin! {
        get {
            return self._pin
        }
        set {
            self._pin = newValue
            coordinate = CLLocationCoordinate2DMake(self._pin!.latitude.doubleValue, self._pin!.longitude.doubleValue)
        }
    }
}
