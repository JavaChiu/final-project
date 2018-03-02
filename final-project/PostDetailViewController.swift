//
//  PostDetailViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 02/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import UIKit
import MapKit

class PostDetailViewController: UIViewController {
    
    // MARK: properties
    var titleText: String?
    var itemImage: UIImage?
    var latitude: Double?
    var longitude: Double?
    var itemDescription: String?
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupFromSegue()
    }
    
    // MARK: private functions
    private func setupFromSegue() {
        if let titleText = self.titleText {
            titleLabel.text = titleText
        }
        
        if let itemImage = self.itemImage {
            self.imageView.image = itemImage
        }
        
        if let latitude = self.latitude, let longitude = self.longitude {
            let initialLocation = CLLocationCoordinate2DMake(latitude, longitude)
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation,                                                                      regionRadius, regionRadius)
            let pin = MapAnnotation(title: "Pick up location",
                                    subtitle: "", coordinate: initialLocation)            
            mapView.setRegion(coordinateRegion, animated: true)
            mapView.addAnnotation(pin)
        }
        
        if let description = self.itemDescription {
            self.descriptionLabel.text = description
        }
    }
    
}
