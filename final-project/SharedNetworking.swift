//
//  SharedNetworking.swift
//  final-project
//
//  Created by Andrew Chiu on 11/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseDatabase
import SystemConfiguration

class SharedNetworking {
    // Static class variable
    static let shared = SharedNetworking()
    private init() {}
    
    var firebaseID: String? = nil {
        didSet {
            print(firebaseID)
        }
    }
    
    // Local cache used to store temporary images
    let cache = NSCache<AnyObject, AnyObject>()
    
    // Firebase storage and database root reference
    let storageRef = Storage.storage().reference()
    var dbRef = Database.database().reference()
    
    // Upload image to firebase
    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?) -> Void) {
        // Check if user is logged in
        guard firebaseID != nil else {
            ErrorHandler.showError(for: SharedNetworkingError.userNotLogined)
            return
        }
        
        // Generate UUID for the image
        let id = UUID()
        // Image reference
        let imageRef = storageRef.child("images/\(id.uuidString)")
        if let uploadData = UIImagePNGRepresentation(image) {
            imageRef.putData(uploadData, metadata: nil) { (metadata, error) in
                if let error = error {
                    ErrorHandler.showError(for: error)
                    completion(nil)
                } else {
                    let url = metadata!.downloadURL()
                    self.cache.setObject(image, forKey: url?.absoluteString
                        as AnyObject)
                    print(url?.absoluteString)
                    completion(url)
                }
            }
        }
    }
    
    func uploadPost(_ post: SinglePost) {
        // Check if user is logged in
        guard let firebaseID = firebaseID else {
            ErrorHandler.showError(for: SharedNetworkingError.userNotLogined)
            return
        }
        
        // Create key for both public and personal feed
        let key = dbRef.child("posts").childByAutoId().key
        let update = ["/posts/\(key)/": post.dict,
                      "/users/\(firebaseID)/\(key)/": post.dict]
        dbRef.updateChildValues(update) { (error, ref) in
            if let error = error {
                ErrorHandler.showError(for: error)
            }
        }
    }

    // Get Image from server
    //    func getFeed(from vc: UIViewController, completion:@escaping (([ImageData]?) -> Void)) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //        guard let url = URL(string: StorageAPI.feed.rawValue) else {
    //            ErrorHandler.showError(for: SharedNetworkingError.invalidURL)
    //            return
    //        }
    //
    //        // Create a url session
    //        let session = URLSession.shared
    //        // Create a data task
    //        session.dataTask(with: url as URL) {(data, response, error) -> Void in
    //            DispatchQueue.main.async {
    //                UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //            }
    //            // Ensure there were no errors returned from the request
    //            guard error == nil else {
    //                ErrorHandler.showErrorAsync(for: error!)
    //                completion(nil)
    //                return
    //            }
    //
    //            // Ensure there is data and unwrap it
    //            guard let data = data else {
    //                ErrorHandler.showErrorAsync(for: SharedNetworkingError.noDataReceived)
    //                completion(nil)
    //                return
    //            }
    //
    //            // Save feed data to Document folder
    //            let docs = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    //            NSKeyedArchiver.archiveRootObject(data, toFile: docs.appending("/feed.plist"))
    //
    //            // Covert JSON to `Feed` type using `JSONDecoder` and `Codable` protocol
    //            do {
    //                let decoder = JSONDecoder()
    //                let feed = try decoder.decode(Feed.self, from: data)
    //
    //                // Call the completion block closure
    //                completion(feed.results)
    //            } catch {
    //                ErrorHandler.showErrorAsync(for: SharedNetworkingError.invalidJSON)
    //                completion(nil)
    //            }
    //        }.resume()
    //    }
    //
    
    
    //    /// Get Image from imageURL
    //    func getImage(from vc: UIViewController, urlString: String, completion:@escaping ((UIImage?) -> Void)) {
    //        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    //
    //        guard let url = URL(string: StorageAPI.base.rawValue+urlString) else {
    //            ErrorHandler.showError(for: SharedNetworkingError.invalidURL)
    //            return
    //        }
    //        if let image = cache.object(forKey: urlString as AnyObject) {
    //            completion(image as? UIImage)
    //        } else {
    //            URLSession.shared.dataTask(with: url) {(data, response, error) -> Void in
    //                DispatchQueue.main.async {
    //                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
    //                }
    //                // Ensure there were no errors returned from the request
    //                guard error == nil else {
    //                    ErrorHandler.showErrorAsync(for: error!)
    //                    return
    //                }
    //
    //                // Ensure there is data and unwrap it
    //                guard let data = data else {
    //                    ErrorHandler.showErrorAsync(for: SharedNetworkingError.noDataReceived)
    //                    return
    //                }
    //
    //                // Return the UIImage
    //                if let image = UIImage(data: data) {
    //                    self.cache.setObject(image, forKey: urlString as AnyObject)
    //                    completion(image)
    //                } else {
    //                    ErrorHandler.showErrorAsync(for: SharedNetworkingError.invalidImageData)
    //                }
    //            }.resume()
    //        }
    //    }
    
    
    // Attribution: https://stackoverflow.com/questions/25623272/how-to-use-scnetworkreachability-in-swift
    func connectedToNetwork() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        #if os(iOS)
            // It's available just for iOS because it's checking if the device is using mobile data
            if flags.contains(.isWWAN) {
                // Device is using mobile data
                return true
            }
        #endif
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
        
    }
}
