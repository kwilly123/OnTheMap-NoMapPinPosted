//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-10.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tabBarController?.tabBar.isHidden = true
        activityIndicator.isHidden = true
        passwordTextField.isSecureTextEntry = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        fieldsChecker()
        UdacityClient.login(self.emailTextField.text!, self.passwordTextField.text!) { (successful, error) in
            
            if error != nil {
                DispatchQueue.main.async {
                    let errorLoginAlert = UIAlertController(title: "Network Error", message: "Could not connect to the network", preferredStyle: .alert)
                    errorLoginAlert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(errorLoginAlert, animated: true, completion: nil)
                    self.setLoggingIn(false)
                }
            }
            
            if successful {
                print("success")
                DispatchQueue.main.async {
                    let mapVC = self.storyboard?.instantiateViewController(identifier: "TabBarController") as! UITabBarController
                    self.navigationController?.pushViewController(mapVC, animated: true)
                    self.setLoggingIn(false)
                }
            } else {
                DispatchQueue.main.async {
                    let invalidLogin = UIAlertController(title: "Invalid Access", message: "Invalid Email or Password", preferredStyle: .alert)
                    invalidLogin.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
                        return
                    }))
                    self.present(invalidLogin, animated: true, completion: nil)
                    self.setLoggingIn(false)
                }
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: Any) {
        let url = UdacityClient.Endpoints.signUp.url
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    private func fieldsChecker(){
        if (emailTextField.text?.isEmpty)! || (passwordTextField.text?.isEmpty)!  {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Credentials were not filled in", message: "Please fill both email and password", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        } else {
            setLoggingIn(true)
        }
    }
    
    func setLoggingIn(_ loggingIn: Bool) { //function handles all of the UI Elements states
        if loggingIn {
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            print("loggin in")
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
}

