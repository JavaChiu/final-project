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
    var id: Int
    var title: String
    var description: String
    var gived: Bool
    var imgUrl: URL
    var pickupAddress: String
    var date: String
    var user: User
}

struct User: Codable {
    var id: Int
    var address: String
    var description: String
    var email: String
    var facebookId: Int
    var userName: String
}

