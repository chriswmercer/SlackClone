//
//  SocketService.swift
//  Smack
//
//  Created by Chris Mercer on 18/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//
import UIKit
import SocketIO

class SocketService: NSObject {
    
    static let instance = SocketService()
    private var manager: SocketManager
    private var socket: SocketIOClient
    public private(set) var isConnected: Bool
    
    override init() {
        manager = SocketManager(socketURL: URL(string: BASE_URL)!, config: [.log(true), .compress])
        socket = manager.defaultSocket
        isConnected = false
        super.init()
    }
    
    func establishConnection() {
        if !isConnected {
            socket.connect()
        }
    }
    
    func closeConnection() {
        socket.disconnect()
        isConnected = false
    }
    
    func addChannel(channelName: String, channelDescription: String, completion: @escaping CompletionHandler) {
        establishConnection()
        socket.emit(SOCKET_EVENT_NEW_CHANNEL, channelName, channelDescription)
        NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
        completion(true)
    }
    
    func getChannel(completion: @escaping CompletionHandler) {
        establishConnection()
        socket.on(SOCKET_EVENT_CHANNEL_CREATED) { (dataArray, ack) in
            guard let channelName = dataArray[0] as? String else { return }
            guard let channelDesc = dataArray[1] as? String else { return }
            guard let channelId = dataArray[2] as? String else { return }
            
            let newChannel = Channel(id: channelId, title: channelName, description: channelDesc)
            MessageService.instance.channels.append(newChannel)
            NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            completion(true)
        }
    }
    
    func addMessage(messageBody: String, userId: String, channelId: String, completion: @escaping CompletionHandler) {
        let user = UserDataService.instance
        socket.emit(SOCKET_EVENT_NEW_MESSAGE, messageBody, userId, channelId, user.name, user.avatarName, user.avatarColour)
        NotificationCenter.default.post(name: NOTIF_MESSAGE_ADDED, object: nil)
        completion(true)
    }
    
    func getMessage(completion: @escaping CompletionHandler) {
        establishConnection()
        socket.on(SOCKET_EVENT_MESSAGE_CREATE) { (dataArray, ack) in
            if AuthService.instance.isLoggedIn {
                guard let mesageBody = dataArray[0] as? String else { return }
                guard let channelId = dataArray[2] as? String else { return }
                guard let userName = dataArray[3] as? String else { return }
                guard let userAvater = dataArray[4] as? String else { return }
                guard let userAvatarColour = dataArray[5] as? String else { return }
                guard let id = dataArray[6] as? String else { return }
                guard let timeStamp = dataArray[7] as? String else { return }
                
                if channelId == MessageService.instance.selectedChannel?.id {
                    let newMessage = Message(message: mesageBody, userName: userName, channelId: channelId, userAvatar: userAvater, userAvatarColour: userAvatarColour, id: id, timeStamp: timeStamp)
                    MessageService.instance.messages.append(newMessage)
                    NotificationCenter.default.post(name: NOTIF_MESSAGE_ADDED, object: nil)
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
}
