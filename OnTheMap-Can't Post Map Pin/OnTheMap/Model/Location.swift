//
//  Location.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-21.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import Foundation

struct Location: Decodable {
    let key: String
    let firstName: String
    let lastName: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case key
    }
}
