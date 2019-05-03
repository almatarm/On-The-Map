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
    
    @IBOutlet weak var refresh: UIBarButtonItem!
    
    var locations: [StudentInformation]! {
        return AppData.shared.locations
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.refresh(self)
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
        refresh.isEnabled = false
        AppData.shared.reload { (error) in
            self.refresh.isEnabled = true
            if let error = error {
                let alertVC = UIAlertController(title: "Loading Data", message: error.localizedDescription, preferredStyle: .alert)
                alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.show(alertVC, sender: nil)
            }
            self.reloadData()
        }
    }
    
    @IBAction func addUser(_ sender: Any) {
    }
}
