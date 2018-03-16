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
//    var id: Int?
    var title: String?
    var postTime: Date?
    var imgURL: URL?
    var description: String?
    var eventTime: Date?
    var latitude: Double?
    var longitude: Double?
    //    var gived: Bool
    var pickupAddress: String {
        return ""
    }
    //    var user: User
    //    var date: String
    
//    var dict: [String: Any?] {
//        return ["title": title,
//                "postTime": postTime?.timeIntervalSince1970,
//                "imgURL": imgURL?.absoluteString,
//                "description": description,
//                "eventTime": eventTime?.timeIntervalSince1970,
//                "latitude": latitude,
//                "longitude": longitude]
//    }
    
    init(title: String, imgURL: URL? = nil, description: String, eventTime: Date, latitude: Double, longitude: Double) {
        self.title = title
        self.postTime = Date()
        self.imgURL = imgURL
        self.description = description
        self.eventTime = eventTime
        self.latitude = latitude
        self.longitude = longitude
    }
    
//    init(_ postDict: NSDictionary) {
//        self.title = postDict.object(forKey: "title") as? String
//        self.postTime = postDict.object(forKey: "postTime")
//        self.imgURL = postDict.object(forKey: "imgURL")
//        self.description = postDict.object(forKey: "description")
//        self.eventTime = postDict.object(forKey: "eventTime")
//        self.latitude = postDict.object(forKey: "latitude")
//        self.longitude = postDict.object(forKey: "longitude")
//    }
}

struct User: Codable {
    var id: Int
    var address: String
    var description: String
    var email: String
    var facebookId: Int
    var userName: String
}

struct MessageOverview: Codable {
    var messageOverViewArray: [SingleMessageOverview]
}

struct SingleMessageOverview: Codable {
    var id: Int
    var shortMessage: String
    var dateTime: String
    var user: User
}

struct Message: Codable {
    var messageDetailArray: [SingleMessageDetail]
}

struct SingleMessageDetail: Codable {
    var id: Int
    var message: String
    var dateTime: String
    var user1: User
    var user2: User
}
