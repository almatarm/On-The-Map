//
//  InfoPostingMapViewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 29/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit
import MapKit

class InfoPostingMapViewController: UIViewController {

    
    var location: CLLocation!
    var mapString: String!
    var link: String!
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //Get map location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)

        let annotation = MKPointAnnotation()
        annotation.title = mapString
        annotation.subtitle = link
        annotation.coordinate = center
        mapView.addAnnotation(annotation)
    }

    
    
    @IBAction func postStudentLocation(_ sender: Any) {
        ParseClient.getMyStudentInformation { (stdLoc, error) in
            var location = stdLoc
            location.mapString = self.mapString
            location.longitude = self.location.coordinate.longitude
            location.latitude = self.location.coordinate.latitude
            location.mediaURL = self.link
            
            ParseClient.postStudentLocation(location: location) { (success, error) in
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else if let error = error {
                    let alertVC = UIAlertController(title: "Posting Student", message: error.localizedDescription, preferredStyle: .alert)
                    alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.show(alertVC, sender: nil)
                }
            }
        }
    }
}
