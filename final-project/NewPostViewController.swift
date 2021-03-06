//
//  NewPostViewController.swift
//  final-project
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//
// Attribution: https://github.com/dillidon/alerts-and-pickers

import UIKit
import CoreLocation
import MapKit

class NewPostViewController: UIViewController {
    // MARK: Properties
    let addPhoto = UIImage(named: "add_photo")
    let formatter = DateFormatter()
    let locationManager = CLLocationManager()
    var postDate = Date()
    var postTime = Date()
    var coordinate = CLLocationCoordinate2D()
    
    // MARK: Outlets and Actions
    @IBOutlet weak var titleLabel: UITextField!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Date Picker
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func addDate(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Date")
        alert.addDatePicker(mode: .date, date: Date()) { date in
            self.formatter.dateFormat = "yyyy-MM-dd"
            self.dateLabel.text = self.formatter.string(from: date)
            self.postDate = date
        }
        alert.addAction(title: "OK", style: .cancel)
        present(alert, animated: true)
    }
    
    // Time Picker
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func addTime(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Time")
        alert.addDatePicker(mode: .time, interval: 15) { time in
            self.formatter.dateFormat = "h:mm a"
            self.timeLabel.text = self.formatter.string(from: time)
            self.postTime = time
        }
        alert.addAction(title: "OK", style: .cancel)
        present(alert, animated: true)
    }
    
    // Location Picker
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBAction func addLocation(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Location")
        alert.addLocationPicker { location in
            if let location = location {
                self.centerMap(on: location)
            }
        }
        alert.addAction(title: "Cancel", style: .cancel)
        present(alert, animated: true)
    }
    
    // Submit Post
    @IBAction func submitPost(_ sender: Any) {
        // Check if user is logged in
        guard SharedNetworking.shared.firebaseID != nil else {
            ErrorHandler.showError(for: SharedNetworkingError.userNotLogined)
            return
        }
        
        // Data integrity checks
        guard let title = titleLabel.text, !title.isEmpty else {
            ErrorHandler.showMessage(title: "What are you giving?", message: "Please give your giveaway a title.")
            return
        }
        
        guard let description = descriptionTextView.text, description != "Describe your giveaway...", !description.isEmpty else {
            ErrorHandler.showMessage(title: "Describe your giveaway...", message: "Please add some details to your giveaway.")
            return
        }
        
        // Build date
        let cal = Calendar.current
        var components = cal.dateComponents([.year, .month, .day, .hour, .minute], from: postDate)
        var timeComponents = cal.dateComponents([.hour, .minute], from: postTime)
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = 0
        let eventTime = cal.date(from: components)!
        
        // Upload photo if available
        if photoImageView.image != addPhoto {
            let resizedImage = photoImageView.image!.resize(to: CGSize(width: 300, height: 300))
            SharedNetworking.shared.uploadImage(resizedImage) { url in
                let post = SinglePost(title: title, imgURL: url, description: description, eventTime: eventTime, latitude: self.coordinate.latitude, longitude: self.coordinate.longitude)
                SharedNetworking.shared.uploadPost(post)
            }
        } else {
            let post = SinglePost(title: title, description: description, eventTime: eventTime, latitude: coordinate.latitude, longitude: coordinate.longitude)
            SharedNetworking.shared.uploadPost(post)
        }
        dismiss(animated: true)
    }
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGesturesToView(photoImageView)
        hideKeyboard()
        photoImageView.image = addPhoto
        
        // Initialize Date and Time label value
        // Calculate rounded time to nearest 15 minute
        // Attribution - https://stackoverflow.com/questions/44736954/round-time-to-nearest-thirty-seconds
        let cal = Calendar.current
        let date = Date()
        let startOfHour = cal.dateInterval(of: .hour, for: date)!.start
        var seconds = date.timeIntervalSince(startOfHour)
        seconds = (seconds/900).rounded(.up) * 900
        let roundedDate = startOfHour.addingTimeInterval(seconds)
        formatter.dateFormat = "yyyy-MM-dd"
        dateLabel.text = formatter.string(from: roundedDate)
        formatter.dateFormat = "h:mm a"
        timeLabel.text = formatter.string(from: roundedDate)
        // Record date and time
        postDate = roundedDate
        postTime = roundedDate
        
        // Initiate Description TextView
        // Attribution: https://stackoverflow.com/questions/27652227/text-view-placeholder-swift
        descriptionTextView.delegate = self
        descriptionTextView.text = "Describe your giveaway..."
        descriptionTextView.textColor = UIColor.lightGray
        
        // Initiate LocationManager
        guard CLLocationManager.locationServicesEnabled() else {
            return
        }
        
        locationManager.delegate = self
        locationManager.headingFilter = kCLHeadingFilterNone
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Check permission status
        let authStatus = CLLocationManager.authorizationStatus()
        
        // Handle all different levels of permissions
        print("switching status")
        switch authStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            presentLocationServicesAlert("Location Services",
                                         message: "Please enable location services for this app in Settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
        }
    }
    
    // Show an alert with information about the location services status
    func presentLocationServicesAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let affirmativeAction = UIAlertAction(title: "OK", style: .default) { (alertAction) -> Void in
            // Launch Settings.app directly to the app
            UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
        }
        alert.addAction(affirmativeAction)
        present(alert, animated: true, completion: nil)
    }
    
    // Center Map on location, add annotation and update addressLabel
    func centerMap(on location: Location) {
        if let address = location.placemark.postalAddress {
            addressLabel.text = "\(address.street), \(address.city) \(address.state) \(address.postalCode)"
        }
        mapView.removeAnnotations(self.mapView.annotations)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = location.name
        self.mapView.addAnnotation(annotation)
        self.coordinate = location.coordinate
    }
}
