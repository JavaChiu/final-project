//
//  DataTypes.swift
//  final-project
//
//  Created by Andrew Chiu on 01/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation

struct Posts: Codable {
    var postArray: [SinglePost]
}

struct SinglePost: Codable {
    var id: Int?
    var title: String
    var postTime: Date?
    var imgURL: URL?
    var description: String
    var eventTime: Date?
    var latitude: Double
    var longitude: Double
    //    var gived: Bool
    var pickupAddress: String {
        return ""
    }
    //    var user: User
    //    var date: String
    
    
    var dict: [String: Any?] {
        return ["title": title,
                "postTime": postTime?.timeIntervalSince1970,
                "imgURL": imgURL?.absoluteString,
                "description": description,
                "eventTime": eventTime?.timeIntervalSince1970,
                "latitude": latitude,
                "longitude": longitude]
    }
    init(title: String, imgURL: URL? = nil, description: String, eventTime: Date, latitude: Double, longitude: Double) {
        self.postTime = Date()
        self.title = title
        self.imgURL = imgURL
        self.description = description
        self.eventTime = eventTime
        self.latitude = latitude
        self.longitude = longitude
    }
}

struct User: Codable {
    var id: Int
    var address: String
    var description: String
    var email: String
    var facebookId: Int
    var userName: String
}

// Error Types for SharedNetworking
enum SharedNetworkingError: Error {
    case invalidURL
    case noDataReceived
    case invalidJSON
    case invalidImageData
    case userNotLogined
}

extension SharedNetworkingError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return NSLocalizedString("Invalid url", comment: "")
        case .noDataReceived:
            return NSLocalizedString("No data received from server.", comment: "")
        case .invalidJSON:
            return NSLocalizedString("Invalide JSON file", comment: "")
        case .invalidImageData:
            return NSLocalizedString("Returned data cannot be converted to UIImage", comment: "")
        case .userNotLogined:
            return NSLocalizedString("User not logged in.", comment: "")
        }
    }
}

enum StorageAPI: String {
    case base = "https://stachesandglasses.appspot.com/"
    case feed = "https://stachesandglasses.appspot.com/user/tclo/json/"
    case upload = "https://stachesandglasses.appspot.com/post/tclo/"
    case recent = "https://stachesandglasses.appspot.com/user/tclo/web/"
}
