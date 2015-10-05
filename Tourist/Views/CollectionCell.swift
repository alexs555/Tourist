//
//  CollectionCell.swift
//  Tourist
//
//  Created by Алексей Шпирко on 30/09/15.
//  Copyright (c) 2015 AlexShpirko LLC. All rights reserved.
//

import UIKit

class CollectionCell: UICollectionViewCell {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var photoImageView: UIImageView!
    
    
    override func prepareForReuse() {
        
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        contentView.bringSubviewToFront(activityIndicator)
        selected = false
        
    }
    
    override var selected: Bool {
        get {
            return super.selected
        }
        set {
            if newValue {
                super.selected = true
                photoImageView.alpha = 0.5
                photoImageView.layer.backgroundColor = UIColor.whiteColor().CGColor!
            } else if newValue == false {
                super.selected = false
                photoImageView.alpha = 1.0
                photoImageView.layer.backgroundColor =  UIColor.clearColor().CGColor!
            }
        }
    }
    
    func setImage(image: UIImage?) {
        
        photoImageView.image = image
        activityIndicator.stopAnimating()
    }
    
}
