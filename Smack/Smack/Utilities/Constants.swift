//
//  Constants.swift
//  Smack
//
//  Created by Chris Mercer on 14/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation

//api url
let BASE_URL = "https://chriswm-chatter.herokuapp.com/v1/"
let URL_REGISTER = BASE_URL + "account/register"
let URL_LOGIN = BASE_URL + "account/login"
let URL_CREATE_USER = BASE_URL + "user/add"

//completion handler
typealias  CompletionHandler = (_ Success: Bool) -> ()

//user defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL_KEY = "userEmail"

//web support
let requestHeader = [
    "Content-Type" : "application/json; charset=utf-8"
]
let RESPONSE_EMAIL_KEY = "user"
let RESPONSE_TOKEN_KEY = "token"

// segues
let TO_LOGIN = "segueToLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"