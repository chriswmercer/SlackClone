//
//  AuthService.swift
//  Smack
//
//  Created by Chris Mercer on 15/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class AuthService {
    static let instance = AuthService()
    
    let defaults = UserDefaults.standard //settings!
    
    var isLoggedIn: Bool {
        get {
            return defaults.bool(forKey: LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: USER_EMAIL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: USER_EMAIL_KEY)
        }
    }
    
    func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let lowerCaseEmail = email.lowercased()
        
        let requestBody: [String:Any] = [
            "email" : lowerCaseEmail,
            "password" : password
        ]
        
        Alamofire.request(URL_REGISTER, method: HTTPMethod.post, parameters: requestBody, encoding: JSONEncoding.default, headers: requestHeader).responseString { (response) in
            if response.result.error == nil {
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let requestBody: [String:Any] = [
            "email" : email,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: HTTPMethod.post, parameters: requestBody, encoding: JSONEncoding.default, headers: requestHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json[RESPONSE_EMAIL_KEY].stringValue
                    self.authToken = json[RESPONSE_TOKEN_KEY].stringValue
                    self.isLoggedIn = true
                    completion(true)
                } catch {
                    debugPrint(error)
                    completion(false)
                }
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    
    
    func createAccount(email: String, password: String, username: String, completion: @escaping CompletionHandler) {
        self.registerUser(email: email, password: password) { (registerSuccess) in
            if registerSuccess {
                self.loginUser(email: email, password: password) { (loginSucces) in
                    if loginSucces {
                        //todo: create user details
                        completion(true)
                    }
                }
            }
        }
        completion(false)
    }
}
