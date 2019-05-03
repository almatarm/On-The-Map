//
//  LocationsViewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 20/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import Foundation
import UIKit

class LocationsViewController: UIViewController {
    var locations: [StudentInformation] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ParseClient.getStudentLocations { (locs, error) in
            self.locations = locs
            self.reloadData()
        }
//        refresh(self)
    }
    
    func reloadData() {
        //Should be overriden by subcalss
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
        ParseClient.getStudentLocations { (locs, error) in
            self.locations = locs
            self.reloadData()
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
    }
}
