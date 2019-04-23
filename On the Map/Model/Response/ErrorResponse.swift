//
//  ErrorResponse.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 21/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable {
    let code: Int
    let message: String
}

extension ErrorResponse: LocalizedError {
    var errorDescription: String? {
        return message
    }
}

