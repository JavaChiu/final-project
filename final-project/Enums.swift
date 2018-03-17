//
//  Enums.swift
//  final-project
//
//  Created by Andrew Chiu on 11/03/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation

enum WebService: String {
    case prefix = "https://ec2-34-211-177-131.us-west-2.compute.amazonaws.com:8443/"
    case mainFeed = "https://ec2-34-211-177-131.us-west-2.compute.amazonaws.com:8443/api/items"
}

enum NetWorkError: Error {
    case noConnection
    case invalidURL
}

// Error Types for SharedNetworking
enum SharedNetworkingError: Error {
    case noDataReceived
    case invalidURL
    case invalidJSON
    case invalidImageData
    case invalidFirebaseDBData
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
        case .invalidFirebaseDBData:
            return NSLocalizedString("Invalid data received from Firebase database.", comment: "")
        case .userNotLogined:
            return NSLocalizedString("User not logged in.", comment: "")
        }
    }
}
