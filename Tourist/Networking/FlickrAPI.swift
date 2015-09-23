//
//  FlickrAPI.swift
//  Tourist
//
//  Created by Алексей Шпирко on 22/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import Alamofire
import MapKit

enum FlickrRouter: URLRequestConvertible {
    
    static let baseURLString = "https://api.flickr.com"
    
    case SearchPhotos(CLLocationCoordinate2D, Int)
    
    // MARK: URLRequestConvertible
    
    var method: Alamofire.Method {
        
        return .GET
    }
    //flickr.photos.getWithGeoData
    var path: String {
    
        return "services/rest"
    }
    
    var URLRequest: NSURLRequest {
        
        let URL = NSURL(string: FlickrRouter.baseURLString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        mutableURLRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        switch self {
            
            case .SearchPhotos(let coordinates, let page):
                
                return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["method": "flickr.photos.search",
                    "format":"json",
                    "nojsoncallback" : "1",
                    "per_page" : "30",
                    "api_key" : "aa992ba8fdf9e28378208a731b66f751",
                    "lat": coordinates.latitude,
                    "lon": coordinates.longitude,
                    "page": page]).0
            default:
                return mutableURLRequest
        }
    }
    
}