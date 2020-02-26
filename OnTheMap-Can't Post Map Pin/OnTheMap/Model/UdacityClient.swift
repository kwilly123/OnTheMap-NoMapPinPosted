//
//  OTMClient.swift
//  OnTheMap
//
//  Created by Kyle Wilson on 2020-02-13.
//  Copyright © 2020 Xcode Tips. All rights reserved.
//

import Foundation

class UdacityClient {
    
    static var accountKey: String = ""
    static var createdAt : String = ""
    static var firstName : String = ""
    static var lastName : String = ""
    static var latitude : Double = 0.0
    static var longitude : Double = 0.0
    static var mapString : String = ""
    static var mediaURL : String = ""
    static var objectId : String = ""
    static var uniqueKey : String = ""
    static var updatedAt : String = ""
    
    enum Endpoints {
        static let studentLocationBaseURL = "https://onthemap-api.udacity.com/v1/StudentLocation"
        static let udacitySessionIdURL = "https://onthemap-api.udacity.com/v1/session"
        static let udacitySignUpURL = "https://auth.udacity.com/sign-up?next=https://classroom.udacity.com/authenticated"
        static let udacityUserDataURL = "https://onthemap-api.udacity.com/v1/users"
        
        case login
        case logout
        case signUp
        case getStudentsLocations(Int, Int)
        case postLocation
        case updateUserLocation(String)
        case getUserData(String)
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.udacitySessionIdURL
            case .signUp:
                return Endpoints.udacitySignUpURL
            case .getStudentsLocations(let limit, let skip):
                return Endpoints.studentLocationBaseURL + "?limit=\(limit)&skip=\(skip)"
            case .postLocation:
                return Endpoints.studentLocationBaseURL
            case .updateUserLocation(let objectId):
                return Endpoints.studentLocationBaseURL + "/\(objectId)"
            case .getUserData(let userId):
                return Endpoints.udacityUserDataURL + "/\(userId)"
            case .logout:
                return Endpoints.udacitySessionIdURL
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
        
    }
    
    class func login(_ email: String,_ password: String, completion: @escaping (Bool, Error?)->()) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\", \"password\": \"\(password)\"}}".data(using: .utf8)
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "")
                return
            }
            
            guard let data = data else {
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            print(String(data: newData, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(LoginResponse.self, from: newData)
                let accountId = decoded.account.key
                self.accountKey = accountId!
                print("The account ID: \(String(describing: accountId))")
                completion(true, nil)
                
            } catch let error {
                print(error.localizedDescription)
                completion(false, nil)
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print("error")
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(Session.self, from: newData)
                print(response)
                completion(true, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(false, error)
                return
            }
            print(String(data: newData, encoding: .utf8)!)
            
        }
        task.resume()
    }
    
    class func getStudentLocations(limit: Int = 100, skip: Int = 0, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentsLocations(limit, skip).url)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                return
            }
            
//            print(String(data: data, encoding: .utf8)!)
            
            do {
                let decoder = JSONDecoder()
                let decoded = try decoder.decode(Result.self, from: data)
                completion(decoded.results, nil)
            } catch let error {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    class func postStudentLocation(student: StudentInformation, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        var request = URLRequest(url: Endpoints.postLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"\(String(describing: student.uniqueKey))\", \"firstName\": \"\(student.firstName)\", \"lastName\": \"\(student.lastName)\",\"mapString\": \"\(String(describing: student.mapString))\", \"mediaURL\": \"\(String(describing: student.mediaURL))\",\"latitude\": \(String(describing: student.latitude)), \"longitude\": \(String(describing: student.longitude))}".data(using: .utf8)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if error != nil {
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PostResponse.self, from: data)
                print(response)
                completion(true, nil)
            } catch let error {
                print(error.localizedDescription)
            }
            
            print(String(data: data, encoding: .utf8)!)
        }
        task.resume()
    }
    
    
    class func updateUserLocation(objectId: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateUserLocation(objectId).url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"uniqueKey\": \"1234\", \"firstName\": \"John\", \"lastName\": \"Doe\",\"mapString\": \"Cupertino, CA\", \"mediaURL\": \"https://udacity.com\",\"latitude\": 37.322998, \"longitude\": -122.032182}".data(using: .utf8)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            print(String(data: data!, encoding: .utf8)!)
        }
        task.resume()
    }
    
    class func getUser(completion: @escaping (_ success: Bool, _ errorString: Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getUserData(accountKey).url)
        request.httpMethod = "GET"
        print(request)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error?.localizedDescription ?? "error")
                return
            }
            
            guard let data = data else {
                completion(false, error?.localizedDescription as? Error)
                return
            }
            
            let range = (5..<data.count)
            let newData = data.subdata(in: range)
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Location.self, from: newData)
                firstName = decodedData.firstName
                lastName = decodedData.lastName
                print(decodedData)
                completion(true, nil)
            } catch let error {
                print(error.localizedDescription)
                completion(false, error.localizedDescription as? Error)
                return
            }
        }
        task.resume()
    }
    
}


