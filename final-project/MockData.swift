//
//  MockData.swift
//  final-project
//
//  Created by Andrew Chiu on 28/02/2018.
//  Copyright © 2018 Andrew Chiu. All rights reserved.
//

import Foundation

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
    
}

var mockDictionary = [
    "postArray": [
        [
            "post_id": 1,
            "title": "This is the first one.",
            "img_url": "imgs/1.png",
            "description": "This is the first one.",
            "latitude": 41.794241,
            "longitude": -87.599056
        ],
        [
            "post_id": 2,
            "title": "This is the second one.",
            "img_url": "imgs/2.png",
            "description": "This is the second one.",
            "latitude": 41.794241,
            "longitude": -87.599056
        ],
        [
            "post_id": 3,
            "title": "This is the third one.",
            "img_url": "imgs/3.png",
            "description": "This is the third one.",
            "latitude": 41.794241,
            "longitude": -87.599056
        ],
        [
            "post_id": 4,
            "title": "This is the forth one.",
            "img_url": "imgs/4.png",
            "description": "This is the forth one.",
            "latitude": 41.794241,
            "longitude": -87.599056
        ]
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: mockDictionary)
let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
