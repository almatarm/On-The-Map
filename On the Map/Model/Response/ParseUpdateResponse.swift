//
//  ParseUpdateResponse.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 03/05/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct ParseUpdateResponse: Codable {
    let objectId: String
    let createdAt: String
    let updatedAt: String
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try map.decodeIfPresent(.objectId) ?? ""
        self.createdAt = try map.decodeIfPresent(.createdAt) ?? ""
        self.updatedAt = try map.decodeIfPresent(.updatedAt) ?? ""
    }
}
