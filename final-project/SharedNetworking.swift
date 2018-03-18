//
//  SharedNetworking.swift
//  final-project
//
//  Created by Andrew Chiu on 11/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import CodableFirebase
import Firebase
import FirebaseStorage
import FirebaseDatabase
import Foundation
import SystemConfiguration
import UIKit

class SharedNetworking {
    // Static class variable
    static let shared = SharedNetworking()
    private init() {}
    
    var firebaseID: String? = nil
    
    // Local cache used to store temporary images
    let cache = NSCache<AnyObject, AnyObject>()
    
    // Firebase storage and database root reference
    let storage = Storage.storage()
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
                    print(url?.absoluteString ?? "no url")
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
        // Create encoded upload
        let data = try! FirebaseEncoder().encode(post)
        // Create key for both public and personal feed
        let key = dbRef.child("posts").childByAutoId().key
        let update = ["/posts/\(key)/": data,
                      "/users/\(firebaseID)/\(key)/": data]
        dbRef.updateChildValues(update) { (error, ref) in
            if let error = error {
                ErrorHandler.showError(for: error)
            }
        }
    }

    // Get Feed from server
    func getFeed(completion:@escaping (([SinglePost]) -> Void)) {
        let feedRef = dbRef.child("posts")
        feedRef.observe(.value) { snapshot in
            print("Getting feed...")
            if let data = snapshot.value as? [String: [String: Any]] {
                do {
                    let posts = try FirebaseDecoder().decode([SinglePost].self, from: Array(data.values))
                    completion(posts)
                } catch {
                    ErrorHandler.showError(for: error)
                }
            } else {
                ErrorHandler.showError(for: SharedNetworkingError.invalidFirebaseDBData)
                
            }
        }
    }
    
    // Get my posts from server
    func getMyPosts(completion:@escaping (([SinglePost]) -> Void)) {
        // Check if user is logged in
        guard let firebaseID = firebaseID else {
            ErrorHandler.showError(for: SharedNetworkingError.userNotLogined)
            return
        }
        let feedRef = dbRef.child("users\(firebaseID)")
        feedRef.observe(.value) { snapshot in
            print("Getting my posts...")
            if let data = snapshot.value as? [String: [String: Any]] {
                do {
                    let posts = try FirebaseDecoder().decode([SinglePost].self, from: Array(data.values))
                    completion(posts)
                } catch {
                    ErrorHandler.showError(for: error)
                }
            } else {
                ErrorHandler.showError(for: SharedNetworkingError.invalidFirebaseDBData)
                
            }
        }
    }
    
    // Get image from url
    func getImage(urlString: String, completion:@escaping ((UIImage?) -> Void)) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true

        guard let _ = URL(string: urlString) else {
            ErrorHandler.showError(for: SharedNetworkingError.invalidURL)
            return
        }
        if let image = cache.object(forKey: urlString as AnyObject) {
            print("Found image in cache")
            completion(image as? UIImage)
        } else {
            let imageRef = storage.reference(forURL: "https://firebasestorage.googleapis.com/b/bucket/o/images%20stars.jpg")
            
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                if let error = error {
                    ErrorHandler.showErrorAsync(for: error)
                    return
                } else {
                    let image = UIImage(data: data!)
                    completion(image)
                }
            }
        }
    }
    
    
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
