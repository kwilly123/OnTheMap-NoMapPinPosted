//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-11.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit
import MapKit

class AddLocationViewController: UIViewController {

    @IBOutlet weak var locationInput: UITextField!
    @IBOutlet weak var findOnTheMapButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        findOnTheMapButton.layer.cornerRadius = 5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.tabBarController?.tabBar.isHidden = false
    }

    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findOnTheMapButtonTapped(_ sender: Any) {
        if locationInput.text!.isEmpty {
            let alert = UIAlertController(title: "No Location", message: "No Location was entered", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let submitVC = storyboard?.instantiateViewController(identifier: "SubmitViewController") as! SubmitViewController
            submitVC.locationRetrieved = locationInput.text
            self.present(submitVC, animated: true, completion: nil)
        }
    }
}
