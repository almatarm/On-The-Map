//
//  UdacityLoginResponse.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 19/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct UdacityAccout: Codable {
    let registered: Bool
    let key: String
}

struct UdacitySession: Codable {
    let id: String
    let expiration: String
}

struct UdacityLoginResponse: Codable {
    let account: UdacityAccout
    let session: UdacitySession
}
