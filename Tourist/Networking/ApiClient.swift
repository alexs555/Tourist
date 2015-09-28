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
    
    
    func fetchPhotosForCoordinates(
        coordinates:CLLocationCoordinate2D,
        page:Int,
        completionHandler: (Array<FlickrPhoto>, NSError?) -> Void) {
        
             Alamofire.request(FlickrRouter.SearchPhotos(coordinates, page)).responseJSON() { (request, response, photosJSON, error) in
                
                println("json \(photosJSON)")
                PhotosDataPovider.parse(photosJSON)
                
            }
            
    }
    
}