//
//  InfoPostingViiewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 29/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingViewController: UIViewController {

    @IBOutlet weak var location: UITextField!
    @IBOutlet weak var link: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func findLocation(_ sender: Any) {
        if let addressString = location.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                if let _ = error  {
                    let alertVC = UIAlertController(title: "Location Not Found!", message: "\(addressString) not found!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                } else if self.link.text == nil || self.link.text!.isEmpty {
                    let alertVC = UIAlertController(title: "LinkIn Link", message: "Enter a valid LinkIn url!", preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertVC, animated: true, completion: nil)
                } else if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    let infoPostingMapVC = self.storyboard?.instantiateViewController(withIdentifier: "InfoPostingMapViewController") as! InfoPostingMapViewController
                    infoPostingMapVC.location = location
                    self.navigationController?.pushViewController(infoPostingMapVC, animated: true)
                }
            }
        }
    }
    
}
