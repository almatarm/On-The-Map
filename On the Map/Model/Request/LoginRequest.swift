//
//  LoginRequest.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 19/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct UsernamePasswordRequest: Codable {
    let username: String
    let password: String
}

struct LoginRequest: Codable {
    let udacity: UsernamePasswordRequest
}
