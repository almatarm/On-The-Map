//
//  StudentLocation.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 21/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

final class StudentLocation: Codable {
    let objectId: String
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
    
    init(from decoder: Decoder) throws {
        let map = try decoder.container(keyedBy: CodingKeys.self)
        self.objectId = try map.decode(.objectId)
        self.uniqueKey = try map.decodeIfPresent(.uniqueKey) ?? ""
        self.firstName = try map.decodeIfPresent(.firstName) ?? ""
        self.lastName = try map.decodeIfPresent(.lastName) ?? ""
        self.mapString = try map.decodeIfPresent(.mapString) ?? ""
        self.mediaURL = try map.decodeIfPresent(.mediaURL) ?? ""
        self.latitude = try map.decodeIfPresent(.latitude) ?? 0.0
        self.longitude = try map.decodeIfPresent(.longitude) ?? 0.0
    }
    
    init(uniqueKey: String, firstName: String, lastName: String) {
        self.objectId = ""
        self.uniqueKey = uniqueKey
        self.firstName = firstName
        self.lastName = lastName
        self.mapString = ""
        self.mediaURL = ""
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
}
