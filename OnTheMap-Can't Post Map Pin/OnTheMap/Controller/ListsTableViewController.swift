//
//  ListsTableViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit

class ListsTableViewController: UITableViewController {
    
    var result = [StudentLocation]()
    @IBOutlet var listTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        result = StudentLocations.lastFetched ?? []
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
    }

    @IBAction func addPinButtonTapped(_ sender: Any) {
        let locationVC = storyboard?.instantiateViewController(identifier: "AddLocationViewController") as! AddLocationViewController
        self.present(locationVC, animated: true, completion: nil)
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
        tableView.reloadData()
    }
    
    func loadStudentLocations() {
        UdacityClient.getStudentLocations { (result, error) in
            
            if error != nil {
                print(error?.localizedDescription ?? "")
                let errorAlert = UIAlertController(title: "Could not load student data", message: "There was an error in trying to retrieve other students data", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
            }
            
            guard result != nil else {
                let errorAlert = UIAlertController(title: "Could not load student data", message: "There was an error in trying to retrieve other students data", preferredStyle: .alert)
                errorAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(errorAlert, animated: true)
                return
            }
            
            StudentLocations.lastFetched = result
            var mapPin = [MKPointAnnotation]()
            
            for location in result! {
                let longitude = CLLocationDegrees(location.longitude!)
                let latitude = CLLocationDegrees(location.latitude!)
                let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                let mediaURL = location.mediaURL
                let firstName = location.firstName
                let lastName = location.lastName
                
                let annotation = MKPointAnnotation()
                annotation.coordinate = coordinates
                annotation.title = "\(String(describing: firstName)) \(String(describing: lastName))"
                annotation.subtitle = mediaURL
                mapPin.append(annotation)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! DataViewCell
        let student = self.result[indexPath.row]
        cell.name.text = "\(student.firstName) \(student.lastName)"
        cell.url.text = student.mediaURL
        if let url = URL(string: cell.url.text!) {
            if url.absoluteString.contains("https://") {
                cell.imageView?.image = UIImage(named: "icon")
            } else {
                cell.imageView?.image = nil
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let url = self.result[indexPath.row].mediaURL
        if let url = URL(string: url!) {
            UIApplication.shared.open(url)
        }
    }

}
