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
    
    func getMyPosts() -> Posts {
        var myPosts: Posts? = nil
        do {
            let decoder = JSONDecoder()
            myPosts = try decoder.decode(Posts.self, from: (myPostJsonString?.data(using: String.Encoding.utf8.rawValue))!)
        } catch {
            print("Error serializing/decoding JSON: \(error)")
        }
        return myPosts!
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
    
    func getMessageOverview() -> MessageOverview {
        var messageOverview: MessageOverview? = nil
        do {
            let decoder = JSONDecoder()
            messageOverview = try decoder.decode(MessageOverview.self, from: (messageOverviewJsonString?.data(using: String.Encoding.utf8.rawValue))!)
        } catch {
            print("Error serializing/decoding JSON: \(error)")
        }
        return messageOverview!
    }
    
    func getMessageDetail(user1Id: Int, user2Id: Int) -> Message {
        var message: Message? = nil
        do {
            let decoder = JSONDecoder()
            message = try decoder.decode(Message.self, from: (messageJsonString?.data(using: String.Encoding.utf8.rawValue))!)
        } catch {
            print("Error serializing/decoding JSON: \(error)")
        }
        return message!
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
            "longitude": -88,
            "latitude": 42
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
            "longitude": -89,
            "latitude": 41
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
            "longitude": -100,
            "latitude": 40
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
            "longitude": -80,
            "latitude": 40
        ]
    ]
]

let jsonData = try! JSONSerialization.data(withJSONObject: mockDictionary)
let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue)

var myPost = [
    "postArray": [
        [
            "id": 1,
            "title": "Some pizzas from party last night",
            "description": "From last night's party. Ordered too much.From last night's party. Ordered too much.From last night's party. Ordered too much.From last night's party. Ordered too much.",
            "imgURL": "imgs/1.png",
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
            "longitude": -88,
            "latitude": 42
        ],
        [
            "id": 2,
            "title": "Sandwiches, still good",
            "description": "first desc",
            "imgURL": "imgs/2.png",
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
            "longitude": -89,
            "latitude": 41
        ]
    ]
]

let myPostJsonData = try! JSONSerialization.data(withJSONObject: myPost)
let myPostJsonString = NSString(data: myPostJsonData, encoding: String.Encoding.utf8.rawValue)

var messageOverViewDictionary = [
    "messageOverViewArray": [
        [
            "id": 0,
            "shortMessage": "What do you wanna tell me?",
            "dateTime": "2018-03-15 14:01",
            "user": [
                "id": 2,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "JLo"
            ]
        ],
        [
            "id": 1,
            "shortMessage": "May I have that hamburger?",
            "dateTime": "2018-03-16 19:20",
            "user": [
                "id": 3,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "PHuarng"
            ]
        ],
        [
            "id": 2,
            "shortMessage": "GREAT APP!",
            "dateTime": "2018-03-16 08:55",
            "user": [
                "id": 4,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "JChen"
            ]
        ]
    ]
]
let messageOverviewJsonData = try! JSONSerialization.data(withJSONObject: messageOverViewDictionary)
let messageOverviewJsonString = NSString(data: messageOverviewJsonData, encoding: String.Encoding.utf8.rawValue)

var messageDictionary = [
    "messageDetailArray": [
        [
            "id": 0,
            "message": " Hey you here me? Let's try a long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long long message",
            "dateTime": "2018-03-16 14:00",
            "user1": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "user2": [
                "id": 2,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "JLo"
            ]
        ],
        [
            "id": 2,
            "message": "Yes I do!!! Very CooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooooL!",
            "dateTime": "2018-03-16 14:00",
            "user1": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "user2": [
                "id": 2,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "JLo"
            ]
        ],
        [
            "id": 3,
            "message": "Glad you like it :)",
            "dateTime": "2018-03-16 14:00",
            "user1": [
                "id": 1,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "AChiu"
            ],
            "user2": [
                "id": 2,
                "address": "somewhere",
                "description": "description",
                "email": "String",
                "facebookId": 123,
                "userName": "JLo"
            ]
        ]
    ]
]
let messageJsonData = try! JSONSerialization.data(withJSONObject: messageDictionary)
let messageJsonString = NSString(data: messageJsonData, encoding: String.Encoding.utf8.rawValue)
