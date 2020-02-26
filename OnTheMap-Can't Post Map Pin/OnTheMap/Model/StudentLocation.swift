//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-13.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import Foundation

struct Result: Codable {
    let results: [StudentLocation]?
}

struct StudentLocation: Codable {
    var createdAt: String?
    var firstName: String
    var lastName: String
    var latitude: Double?
    var longitude: Double?
    var mapString: String?
    var mediaURL: String?
    var objectId: String?
    var uniqueKey: String?
    var updatedAt: String?
    
    init(createdAt: String, firstName: String, lastName: String, latitude: Double, longitude: Double, mapString: String, mediaURL: String, objectId: String, uniqueKey: String, updatedAt: String) {
        self.createdAt = createdAt
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.mediaURL = mediaURL
        self.objectId = objectId
        self.uniqueKey = uniqueKey
        self.updatedAt = updatedAt
    }
}
