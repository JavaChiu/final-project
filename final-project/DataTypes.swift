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

/// Data about the `Article`
struct SinglePost: Codable {
    var post_id: Int
    var title: String
    var img_url: URL
    var description: String
    var latitude: Double
    var longitude: Double
}
