//
//  AppData.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 04/05/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation

class AppData {
    var locations: [StudentInformation] = []
    
    static let shared = AppData()
    
    func reload(completion: @escaping (Error?) -> Void) {
        ParseClient.getStudentLocations { (locs, error) in
            self.locations = locs
            completion(error)
        }
    }
}
