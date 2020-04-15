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

//completion handler
typealias  CompletionHandler = (_ Success: Bool) -> ()

//user defaults
let LOGGED_IN_KEY = "loggedIn"
let TOKEN_KEY = "token"
let USER_EMAIL_KEY = "userEmail"

// segues
let TO_LOGIN = "segueToLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"
