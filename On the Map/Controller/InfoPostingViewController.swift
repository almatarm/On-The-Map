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
    @IBOutlet weak var findLocationButton: StyledButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func findLocation(_ sender: Any) {
        networkRequestInProgress(true)
        if let addressString = location.text {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(addressString) { (placemarks, error) in
                self.networkRequestInProgress(false)
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
                    infoPostingMapVC.mapString = self.location.text
                    infoPostingMapVC.link = self.link.text
                    self.navigationController?.pushViewController(infoPostingMapVC, animated: true)
                }
            }
        }
    }
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func networkRequestInProgress(_ isRequestInProgress: Bool) {
        location.isEnabled = !isRequestInProgress
        link.isEnabled = !isRequestInProgress
        findLocationButton.isEnabled = !isRequestInProgress
        activityIndicator.isHidden = !isRequestInProgress
        
        if isRequestInProgress {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
    }
}
