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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func logout(_ sender: Any) {
        UdacityClient.logout {
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func refresh(_ sender: Any) {
    }
    
    @IBAction func addUser(_ sender: Any) {
    }
}
