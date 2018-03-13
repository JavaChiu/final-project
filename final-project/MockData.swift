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
            "id": 1,
            "title": "This is the first one.",
            "description": "first desc",
            "imgUrl": "imgs/1.png",
            "gived": false,
            "pickupAddress": "somewhere"
        ],
        [
            "id": 2,
            "title": "This is the second one.",
            "description": "first desc",
            "imgUrl": "imgs/1.png",
            "gived": false,
            "pickupAddress": "somewhere"
        ],
        [
            "id": 3,
            "title": "This is the third one.",
            "description": "first desc",
            "imgUrl": "imgs/1.png",
            "gived": false,
            "pickupAddress": "somewhere"
        ],
        [
            "id": 4,
            "title": "This is the forth one.",
            "description": "first desc",
            "imgUrl": "imgs/1.png",
            "gived": false,
            "pickupAddress": "somewhere"
        ]
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: mockDictionary)
let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)
