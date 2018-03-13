//
//  SharedNetworking.swift
//  final-project
//
//  Created by Andrew Chiu on 11/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation
import UIKit
import SystemConfiguration

class SharedNetworking {
    static let sharedInstance = SharedNetworking()

    private init() {}
    
    func getMainFeed(url: String, completion:@escaping (Posts?) -> Void) throws {

        guard connectedToNetwork() else {
            throw NetWorkError.noConnection
        }

        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            throw NetWorkError.invalidURL
        }
        print(url)

        // Create a url session
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in

            // Print out the response (for debugging purpose)
            print("Response: \(String(describing: response))")

            // Ensure there were no errors returned from the request
            guard error == nil else {
                print(error ?? "unknown error")
                completion(nil)
                return
            }

            // Ensure there is data and unwrap it
            guard let data = data else {
                print("Data is nil")
                completion(nil)
                return
            }

            // Print out for debugging
            print("Raw data: \(data)")


            // Covert JSON to `News` type using `JSONDecoder` and `Codable` protocol
            do {
                let decoder = JSONDecoder()
                let mainFeed = try decoder.decode(Posts.self, from: data)

                // Call the completion block closure with the news data
                completion(mainFeed)
            } catch {
                print("Error serializing/decoding JSON: \(error)")
                completion(nil)
            }
        })

        // Tasks start off in suspended state, we need to kick it off
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func getImage(url: String, completion:@escaping (Data?) -> Void) throws {

        guard connectedToNetwork() else {
            throw NetWorkError.noConnection
        }

        // Transform the `url` parameter argument to a `URL`
        guard let url = NSURL(string: url) else {
            throw NetWorkError.invalidURL
        }
        print(url)

        // Create a url session
        let session = URLSession.shared

        // Create a data task
        let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in

            // Print out the response (for debugging purpose)
            print("Response: \(String(describing: response))")

            // Ensure there were no errors returned from the request
            guard error == nil else {
                print(error ?? "unknown error")
                completion(nil)
                return
                // fatalError("Error: \(error!.localizedDescription)")
            }

            // Ensure there is data and unwrap it
            guard let data = data else {
                print("Data is nil")
                completion(nil)
                return
            }

            // Print out for debugging
            print("Raw data: \(data)")

            completion(data)
        })

        // Tasks start off in suspended state, we need to kick it off
        task.resume()
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }

    func uploadRequest(user: NSString, image: UIImage, caption: NSString, completion:@escaping (Int) -> Void) throws {
        guard connectedToNetwork() else {
            throw NetWorkError.noConnection
        }

        // Transform the `url` parameter argument to a `URL`
//        guard let url = NSURL(string: WebService.post.rawValue + (user as String) + "/") else {
//            throw NetWorkError.invalidURL
//        }
//
//
//        let boundary = generateBoundaryString()
//        let imageJPEGData = UIImageJPEGRepresentation(image,0.1)
//
//        guard let imageData = imageJPEGData else {return}
//
//        // Create the request
//        let request = NSMutableURLRequest(url: url as URL)
//        request.httpMethod = "POST"
//        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        // Set the type of the data being sent
//        let mimetype = "image/jpeg"
//        // This is not necessary
//        let fileName = "test.png"
//
//        // Create data for the body
//        let body = NSMutableData()
//        body.append("\r\n--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//
//        // Caption data (this is optional)
//        body.append("Content-Disposition:form-data; name=\"caption\"\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append("CaptionText\r\n".data(using: String.Encoding.utf8)!)
//
//        // Image data
//        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Disposition:form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: String.Encoding.utf8)!)
//        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
//        body.append(imageData)
//        body.append("\r\n".data(using: String.Encoding.utf8)!)
//
//        // Trailing boundary
//        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)
//
//        // Set the body in the request
//        request.httpBody = body as Data
//
//        // Create a data task
//        let session = URLSession.shared
//        _ = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
//            let httpResponse = response as! HTTPURLResponse
//
//            // The data returned is the update JSON list of all the images
//            let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
//            print(dataString as Any)
//
//            guard error == nil else {
//                print("error calling POST on /todos/1")
//                completion(httpResponse.statusCode)
//                return
//            }
//
//            completion(httpResponse.statusCode)
//            }.resume()
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true

    }

    /// A unique string that signifies breaks in the posted data
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().uuidString)"
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

