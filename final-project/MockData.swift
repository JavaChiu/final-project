//
//  MockData.swift
//  final-project
//
//  Created by Andrew Chiu on 28/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation
import UIKit

class MockData {
    
    static let sharedInstance = MockData()
    private init() {}
    
    func getAllPost() -> Posts {
        // Attribution: https://stackoverflow.com/questions/39616821/swift-3-0-data-to-string
        var posts: Posts? = nil
        do {
            let decoder = JSONDecoder()
            posts = try decoder.decode(Posts.self, from: (jsonString?.data(using: String.Encoding.utf8.rawValue))!)
        } catch {
            print("Error serializing/decoding JSON: \(error)")
        }
        return posts!
    }
    
    func getItemImage(url: URL) -> UIImage {
        var itemImage:UIImage? = nil
        
        switch url.absoluteString {
        case "imgs/1.png":
            itemImage = UIImage(named: "pizza")
        case "imgs/2.png":
            itemImage = UIImage(named: "sandwiches")
        case "imgs/3.png":
            itemImage = UIImage(named: "bread")
        case "imgs/4.png":
            itemImage = UIImage(named: "noodles")
        default:
            break
        }
        
        return itemImage!
    }
    
    func getUserImage(url: URL) -> UIImage {
        var userImage:UIImage? = nil
        
        switch url.absoluteString {
        case "imgs/1.png":
            userImage = UIImage(named: "person")
        case "imgs/2.png":
            userImage = UIImage(named: "person")
        case "imgs/3.png":
            userImage = UIImage(named: "person")
        case "imgs/4.png":
            userImage = UIImage(named: "person")
        default:
            userImage = UIImage(named: "person")
            break
        }
        
        return userImage!
    }
}

var mockDictionary = [
    "postArray": [
        [
            "id": 1,
            "title": "Some pizzas from party last night",
            "description": "From last night's party. Ordered too much.From last night's party. Ordered too much.From last night's party. Ordered too much.From last night's party. Ordered too much.",
            "imgUrl": "imgs/1.png",
            "gived": false,
            "pickupAddress": "5400 South Drexel Avenue",
            "date": "2018-03-13",
            "user": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "longitude": 1,
            "latitude": 1
        ],
        [
            "id": 2,
            "title": "Sandwiches, still good",
            "description": "first desc",
            "imgUrl": "imgs/2.png",
            "gived": false,
            "pickupAddress": "5400 South Drexel Avenue",
            "date": "2018-03-13",
            "user": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "longitude": 1,
            "latitude": 1
        ],
        [
            "id": 3,
            "title": "Fresh bread",
            "description": "first desc",
            "imgUrl": "imgs/3.png",
            "gived": false,
            "pickupAddress": "5400 South Drexel Avenue",
            "date": "2018-03-13",
            "user": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "longitude": 1,
            "latitude": 1
        ],
        [
            "id": 4,
            "title": "Instant noodles",
            "description": "first desc",
            "imgUrl": "imgs/4.png",
            "gived": false,
            "pickupAddress": "5400 South Drexel Avenue",
            "date": "2018-03-13",
            "user": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "longitude": 1,
            "latitude": 1
        ]
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: mockDictionary)
let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
