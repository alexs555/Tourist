//
//  ViewController.swift
//  Tourist
//
//  Created by Алексей Шпирко on 06/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let coords = CLLocationCoordinate2DMake(55.7522200,37.6155600)

        
        ApiClient.defaultClient.fetchPhotosForCoordinates(coords, page: 1, completionHandler: {
            photos, error in
            
            println(photos)
            
        })
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

