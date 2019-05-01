//
//  UdacityUserResponse.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 01/05/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

final class UdacityUser: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.uniqueKey = try map.decodeIfPresent(.uniqueKey) ?? ""
        self.firstName = try map.decodeIfPresent(.firstName) ?? ""
        self.lastName = try map.decodeIfPresent(.lastName) ?? ""
    }
    
    private enum CodingKeys : String, CodingKey {
        case uniqueKey = "key", firstName = "first_name", lastName = "last_name"
    }
}
