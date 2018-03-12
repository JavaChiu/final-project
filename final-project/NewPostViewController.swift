//
//  NewPostViewController.swift
//  final-project-mock-up
//
//  Created by Andrew Chiu on 18/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//
// Attribution: https://github.com/dillidon/alerts-and-pickers

import UIKit
import CoreLocation
import MapKit

class NewPostViewController: UIViewController {
    // Properties
    let addPhoto = UIImage(named: "add_photo")
    let formatter = DateFormatter()
    let locationManager = CLLocationManager()
    
    // MARK: Outlets and Actions
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBAction func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    // Date Picker
    @IBOutlet weak var dateLabel: UILabel!
    @IBAction func addDate(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Date")
        alert.addDatePicker(mode: .date, date: Date()/*, minimumDate: minDate, maximumDate: maxDate*/) { date in
            // action with selected date
            print(date)
            self.formatter.dateFormat = "yyyy-MM-dd"
            self.dateLabel.text = self.formatter.string(from: date)
        }
        alert.addAction(title: "OK", style: .cancel)
        present(alert, animated: true)
    }
    
    // Time Picker
    @IBOutlet weak var timeLabel: UILabel!
    @IBAction func addTime(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select Time")
        alert.addDatePicker(mode: .time, interval: 15) { date in
            self.formatter.dateFormat = "h:mm a"
            self.timeLabel.text = self.formatter.string(from: date)
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
    
    @IBAction func submitPost(_ sender: Any) {
    }

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addPanGesturesToView(photoImageView)
        hideKeyboard()

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
        addressLabel.text = location.address
        mapView.removeAnnotations(self.mapView.annotations)
        let span = MKCoordinateSpanMake(0.01, 0.01)
        let region = MKCoordinateRegion(center: location.coordinate, span: span)
        self.mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location.coordinate
        annotation.title = location.name
        self.mapView.addAnnotation(annotation)
    }
}
