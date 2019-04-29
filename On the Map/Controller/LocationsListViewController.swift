//
//  LocationListViewController.swift
//  On the Map
//
//  Created by Mufeed AlMatar on 20/04/2019.
//  Copyright © 2019 GreenX. All rights reserved.
//

import UIKit

class LocationsListViewController: LocationsViewController, UITableViewDataSource, UITableViewDelegate {
    static let cellIdentifer = "StudentLocationCell"
    
    @IBOutlet weak var locationsTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationsTable.dataSource = self
        locationsTable.delegate = self
    }
    
    override func reloadData() {
        locationsTable.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: LocationsListViewController.cellIdentifer)!
        
        let studentLocation = locations[indexPath.row]
        
        cell.textLabel?.text = studentLocation.lastName + ", " + studentLocation.firstName + ", " + studentLocation.mapString
        cell.detailTextLabel?.text = studentLocation.mediaURL
        cell.imageView?.image = UIImage(named: "icon_pin")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let studentLocation = locations[indexPath.row]
        if URL(string: studentLocation.mediaURL) != nil {
            UIApplication.shared.open(URL(string: studentLocation.mediaURL)!, options: [:])
        }
    }
}
