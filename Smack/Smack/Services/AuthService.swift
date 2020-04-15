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
            return defaults.bool(forKey: DEFAULTS_LOGGED_IN_KEY)
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_LOGGED_IN_KEY)
        }
    }
    
    var authToken: String {
        get {
            return defaults.value(forKey: DEFAULTS_TOKEN_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_TOKEN_KEY)
        }
    }
    
    var userEmail: String {
        get {
            return defaults.value(forKey: DEFAULTS_USER_EMAIL_KEY) as! String
        }
        set {
            defaults.set(newValue, forKey: DEFAULTS_USER_EMAIL_KEY)
        }
    }
    
    func createAccount(email: String, password: String, username: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        self.registerUser(email: email, password: password) { (registerSuccess) in
            if registerSuccess {
                self.loginUser(email: email, password: password) { (loginSucces) in
                    if loginSucces {
                        self.createUser(email: email, name: username, avatarName: avatarName, avatarColor: avatarColor, completion: completion)
                        completion(true)
                    }
                }
            }
        }
        completion(false)
    }
    
    private func registerUser(email: String, password: String, completion: @escaping CompletionHandler) {
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
    
    private func loginUser(email: String, password: String, completion: @escaping CompletionHandler) {
        let requestBody: [String:Any] = [
            "email" : email,
            "password" : password
        ]
        
        Alamofire.request(URL_LOGIN, method: HTTPMethod.post, parameters: requestBody, encoding: JSONEncoding.default, headers: requestHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    self.userEmail = json[RESPONSE_USERNAME_KEY].stringValue
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
    
    private func createUser(email: String, name: String, avatarName: String, avatarColor: String, completion: @escaping CompletionHandler) {
        let requestBody: [String:Any] = [
            "name" : name,
            "email" : email,
            "avatarName" : avatarName,
            "avatarColor" : avatarColor
        ]
        
        let headers = [
            "Authorization" : "Bearer \(authToken)",
            "Content-Type" : "application/json; charset=utf-8"
        ]
        
        Alamofire.request(URL_CREATE_USER, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: headers).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                
                do {
                    let json = try JSON(data: data)
                    let id = json[RESPONSE_ID_KEY].stringValue
                    let name = json[RESPONSE_NAME_KEY].stringValue
                    let color = json[RESPONSE_AVATAR_COLOUR_KEY].stringValue
                    let avatarName = json[RESPONSE_AVATAR_NAME_KEY].stringValue
                    let email = json[RESPONSE_EMAIL_KEY].stringValue
                    
                    UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
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
}
