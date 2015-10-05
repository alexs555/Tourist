//
//  ApiClient.swift
//  Tourist
//
//  Created by Алексей Шпирко on 23/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import MapKit
import Alamofire
import SwiftyJSON

class ApiClient {
    
    static let defaultClient = ApiClient()
    
    func fetchPhotosForPin(
        pin:Pin,
        page:Int,
        completionHandler: (Array<Photo>, NSError?) -> Void) {
        
             Alamofire.request(FlickrRouter.SearchPhotos(CLLocationCoordinate2DMake(pin.latitude.doubleValue, pin.longitude.doubleValue), page)).responseJSON() { (request, response, photosJSON, error) in
                
                println("json \(photosJSON)")
                var photos = PhotosDataPovider.parse(photosJSON,pin:pin)
                completionHandler(photos, error)
                
            }
            
    }
    
}