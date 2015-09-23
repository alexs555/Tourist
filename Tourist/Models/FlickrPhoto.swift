//
//  FlickrPhoto.swift
//  Tourist
//
//  Created by Алексей Шпирко on 24/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation

struct FlickrPhoto {
    
    private(set) var url: NSURL
    private(set) var title: String
    private(set) var filename: String
    
    private var photoId: String
    private var server: String
    private var secret: String
    private var farm: Int
    
    init(dictionary: [NSObject: AnyObject]) {
        
        photoId = dictionary["id"] as! String
        title = dictionary["title"] as! String
        server = dictionary["server"] as! String
        secret = dictionary["secret"] as! String
        farm = dictionary["farm"] as! Int
        filename = "\(photoId)_\(secret).jpg"
        
        url = NSURL(string: "https://farm\(farm).staticflickr.com/\(server)/\(filename)")!
    }
}