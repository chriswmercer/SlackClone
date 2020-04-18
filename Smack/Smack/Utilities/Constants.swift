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
let URL_USER_BY_EMAIL = BASE_URL + "user/byEmail/"
let URL_GET_CHANNELS = BASE_URL + "channel/"
let URL_GET_MESSAGES = BASE_URL + "message/byChannel"

//completion handler
typealias  CompletionHandler = (_ Success: Bool) -> ()

//user defaults
let DEFAULTS_LOGGED_IN_KEY = "loggedIn"
let DEFAULTS_TOKEN_KEY = "token"
let DEFAULTS_USER_EMAIL_KEY = "userEmail"

//web support
let requestHeader = [
    "Content-Type" : "application/json; charset=utf-8"
]
let bearerHeader = [
    "Authorization" : "Bearer \(AuthService.instance.authToken)",
    "Content-Type" : "application/json; charset=utf-8"
]
let RESPONSE_USERNAME_KEY = "user"
let RESPONSE_TOKEN_KEY = "token"
let RESPONSE_ID_KEY = "_id"
let RESPONSE_NAME_KEY = "name"
let RESPONSE_AVATAR_COLOUR_KEY = "avatarColor"
let RESPONSE_AVATAR_NAME_KEY = "avatarName"
let RESPONSE_EMAIL_KEY = "email"
let RESPONSE_MESSAGE_KEY = "message"

// segues
let TO_LOGIN = "segueToLogin"
let TO_CREATE_ACCOUNT = "toCreateAccount"
let UNWIND_TO_CHANNEL = "unwindToChannel"
let TO_AVATAR_PICKER = "segueToPickAvatar"

// reuse identifiers - i may have missed some
let REUSE_ID_AVATAR_IMAGE_CELL = "avatarImageCell"

//colours
let smackPurplePlaceHolder = #colorLiteral(red: 0.3254901961, green: 0.4196078431, blue: 0.7764705882, alpha: 0.5043519295)

//notificatons
let NOTIF_USER_DATA_DID_CHANGE = Notification.Name("notifUserDataDidChange")
let NOTIF_CHANNEL_DATA_DID_CHANGE = Notification.Name("notifChanelDataDidChange")
let NOTIF_CHANNEL_SELECT = Notification.Name("notifyChannelSelected")

//socket events
let SOCKET_EVENT_NEW_CHANNEL = "newChannel"
let SOCKET_EVENT_CHANNEL_CREATED = "channelCreated"
let SOCKET_EVENT_NEW_MESSAGE = "newMessage"
