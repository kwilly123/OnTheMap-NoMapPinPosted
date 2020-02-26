//
//  LoginResponse.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-13.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: Account
    let session: Session
}

struct PostResponse: Codable {
    var createdAt: String
    var objectId: String
}

struct Account: Codable {
    let registered: Bool?
    let key: String?
}

struct Session: Codable {
    let id: String?
    let expiration: String?
}
