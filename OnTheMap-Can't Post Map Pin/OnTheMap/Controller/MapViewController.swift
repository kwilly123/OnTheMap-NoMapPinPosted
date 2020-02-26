//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MapViewController: UIViewController {
    
    @IBOutlet weak var addPinButton: UIBarButtonItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var refreshButton: UIBarButtonItem!
    @IBOutlet weak var onTheMapNavItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        loadStudentLocations()
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
                annotation.title = "\(firstName) \(lastName)"
                annotation.subtitle = mediaURL
                mapPin.append(annotation)
                
            }
            DispatchQueue.main.async {
                self.mapView.addAnnotations(mapPin)
            }
        }
    }
    
    @IBAction func refreshButtonTapped(_ sender: Any) {
        loadStudentLocations()
    }
    
    @IBAction func addPinButtonTapped(_ sender: Any) {
        let locationVC = storyboard?.instantiateViewController(identifier: "AddLocationViewController") as! AddLocationViewController
        self.present(locationVC, animated: true, completion: nil)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        UdacityClient.logout { (success, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Could not log out", message: "Error logging out.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            
            if success {
                print("logged out")
                DispatchQueue.main.async {
                   let lvc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController
                    self.navigationController?.pushViewController(lvc!, animated: true)
                }
            } else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Could not log out", message: "Error logging out.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView?.canShowCallout = true
            pinView?.pinTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView?.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let open = view.annotation?.subtitle {
                guard let url = URL(string: open!) else { return }
                openInSafari(url: url)
            }
        }
    }
    
    func openInSafari(url: URL) {
        if url.absoluteString.contains("https://") {
            let safariVC = SFSafariViewController(url: url)
            self.present(safariVC, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Invalid URL", message: "Could not load URL", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
