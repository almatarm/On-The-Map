//
//  UdacityErrorResponse.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 18/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct UdacityErrorResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    
    enum CodingKeys: String, CodingKey {
        case statusCode = "status"
        case statusMessage = "error"
    }
}

extension UdacityErrorResponse: LocalizedError {
    var errorDescription: String? {
        return statusMessage
    }
}
