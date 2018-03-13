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
