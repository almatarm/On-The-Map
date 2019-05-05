//
//  StudentLocation.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 21/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

struct StudentInformation: Codable {
    let objectId: String
    let uniqueKey: String
    var firstName: String
    var lastName: String
    var mapString: String
    var mediaURL: String
    var latitude: Double
    var longitude: Double
    
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
    
    enum CodingKeys: String, CodingKey {
        case objectId, uniqueKey, firstName, lastName, mapString, mediaURL, latitude, longitude
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(uniqueKey, forKey: .uniqueKey)
        try container.encode(firstName, forKey: .firstName)
        try container.encode(lastName, forKey: .lastName)
        try container.encode(mapString, forKey: .mapString)
        try container.encode(mediaURL, forKey: .mediaURL)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}
