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
    
    func login(email: String, password: String, completion: @escaping CompletionHandler) {
        loginUser(email: email, password: password) { (success) in
            if success {
                self.findUserByEmail { (findSuccess) in
                    if findSuccess {
                        MessageService.instance.findAllChannels { (success) in
                            if success {
                                print("Logged In")
                                completion(true)
                            } else {
                                completion(false)
                            }
                        }

                    } else {
                        print("Could not log in")
                        completion(false)
                    }
                }
            } else {
                completion(false)
            }
        }
    }
    
    func wakeUser(completion: @escaping CompletionHandler) {
        findUserByEmail { (success) in
            if success {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    func logout() {
        isLoggedIn = false
        authToken = ""
        userEmail = ""
        UserDataService.instance.resetDetails()
        MessageService.instance.clearChannels()
    }
    
    private func findUserByEmail(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_USER_BY_EMAIL + userEmail, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
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
                    let returnedUserNAme = json[RESPONSE_USERNAME_KEY].stringValue
                    
                    if returnedUserNAme == "" {
                        let message = json[RESPONSE_MESSAGE_KEY].stringValue
                        print(message)
                        completion(false)
                    }
                    
                    self.userEmail = returnedUserNAme
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
        
        Alamofire.request(URL_CREATE_USER, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                self.setUserInfo(data: data)
                completion(true)
            } else {
                completion(false)
                debugPrint(response.result.error as Any)
            }
        }
    }
    
    private func setUserInfo(data: Data) {
        do {
            let json = try JSON(data: data)
            let id = json[RESPONSE_ID_KEY].stringValue
            let name = json[RESPONSE_NAME_KEY].stringValue
            let color = json[RESPONSE_AVATAR_COLOUR_KEY].stringValue
            let avatarName = json[RESPONSE_AVATAR_NAME_KEY].stringValue
            let email = json[RESPONSE_EMAIL_KEY].stringValue
            
            UserDataService.instance.setUserData(id: id, color: color, avatarName: avatarName, email: email, name: name)
        } catch {
            print(error)
        }
    }
}
