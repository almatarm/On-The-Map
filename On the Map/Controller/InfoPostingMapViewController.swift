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
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
  
        //Get map location
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(region, animated: true)

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
