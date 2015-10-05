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
   
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2DMake(pin.latitude.doubleValue, pin.longitude.doubleValue)
        }
        set {
            pin.latitude = newValue.latitude
            pin.longitude = newValue.longitude
        }
    }
    
    var title: String?
    var subtitle: String?
    var pin:Pin!
}
