//
//  ImagesStorage.swift
//  Tourist
//
//  Created by Алексей Шпирко on 24/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import Foundation
import UIKit

class ImagesStorage {
    
    private static let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
    
    func imageWithUrl(url: NSURL, filename: String, completion: (image: UIImage?) -> Void) {
        
        if let image = cachedImageWithFilename(filename) {
            
            completion(image: image)
            return
        }
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { data, response, error in
            
            if error != nil {
                completion(image: nil)
                return
            }
            
            var image: UIImage?
            
            let httpResponse = response as! NSHTTPURLResponse
            if httpResponse.statusCode == 200 {
                
                self.saveImageDataWithFilename(data, filename: filename)
                image = UIImage(data: data)
            }
            
            dispatch_async(dispatch_get_main_queue(), {
                completion(image: image)
            })
        })
        task.resume()
    }
    
    static func getPathForFilename(filename: String) -> String {
        
        return directory.stringByAppendingPathComponent(filename)
    }
    
    private func saveImageDataWithFilename(imageData: NSData, filename: String) {
        
        imageData.writeToFile(ImagesStorage.getPathForFilename(filename), atomically: true)
    }
    
    private func cachedImageWithFilename(filename: String) -> UIImage? {
        
        let image = UIImage(contentsOfFile: ImagesStorage.getPathForFilename(filename))
        return image
    }
    
    
}