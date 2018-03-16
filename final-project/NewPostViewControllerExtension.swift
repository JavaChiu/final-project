//
//  NewPostViewControllerExtension.swift
//
//
//  Created by Jerry Lo on 2/25/18.
//

import UIKit
import Foundation
import CoreLocation
import MapKit

extension NewPostViewController: UITextViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate {
    // MARK: Gesture Recognizers
    
    /// Add tap gestures to a view
    /// - Parameter view: The view to attach the gestures to
    func addPanGesturesToView(_ view: UIView) {
        view.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(NewPostViewController.addNewMedia(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    /// Show and Hide the navigation bar and adjust size of image view
    /// - Parameter recognizer: The gesture that is recognized
    @objc func addNewMedia(_ recognizer:UITapGestureRecognizer) {
        MediaManager.shared.showActionSheet(vc: self, removePhoto: !(photoImageView.image==addPhoto))
        MediaManager.shared.imageProcessing = {(image) in
            if let image = image {
                self.photoImageView.image = image
                self.photoImageView.contentMode = .scaleAspectFill
            } else {
                self.photoImageView.image = self.addPhoto
                self.photoImageView.contentMode = .center
            }
        }
    }
    
    // MARK: UITextView Delegate Methods
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Describe your giveaway..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    // MARK: UITextField Delegate Methods
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: CLLocationManagerDelegate Delegate Methods
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(locations.last!) { (placemarks, error) in
            if error == nil {
                let placemark = placemarks![0]
                let location = Location(name: "My Location", location: locations.last, placemark: placemark)
                self.centerMap(on: location)
            }
        }
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}

