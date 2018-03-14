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
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var itemDescription: String?
    var date: String?
    var userImage: UIImage?
    var userName: String?
    let regionRadius: CLLocationDistance = 1000
    
    // MARK: outlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    
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
        
        if let address = self.address {
            self.addressLabel.text = address
            
            //
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        return
                }
                
                // Use your location
                let initialLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
                let coordinateRegion = MKCoordinateRegionMakeWithDistance(initialLocation,                                                                      self.regionRadius, self.regionRadius)
                self.mapView.setRegion(coordinateRegion, animated: true)
                
                let pin = MapAnnotation(title: "Pick up location",
                                        subtitle: "", coordinate: initialLocation)
                self.mapView.addAnnotation(pin)
            }
        }
        
        if let description = self.itemDescription {
            self.descriptionLabel.text = description
        }
        
        if let date = self.date {
            self.dateLabel.text = date
        }
        
        if let user = self.userName {
            self.userNameLabel.text = user
        }
        
        if let userImage = self.userImage {
            self.userImageView.image = userImage
        }
    }
    
}
