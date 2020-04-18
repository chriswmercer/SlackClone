//
//  MessageService.swift
//  Smack
//
//  Created by Chris Mercer on 17/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MessageService {
    
    static let instance = MessageService()
    
    var channels = [Channel]()
    var selectedChannel: Channel?
    
    var messages = [Message]()
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do
                {
                    if let json = try JSON(data: data).array {
                        self.clearChannels()
                        for item in json {
                            let name = item["name"].stringValue
                            let description = item["description"].stringValue
                            let id = item["_id"].stringValue
                            let channel = Channel(id: id, title: name, description: description)
                            self.channels.append(channel)
                        }
                        completion(true)
                        return
                    }
                } catch {
                    debugPrint(error as Any)
                }
            } else {
                debugPrint(response.result.error as Any)
            }
            
            completion(false)
        }
    }
    
    func clearChannels() {
        channels.removeAll()
    }
    
    func findAllMessagesForChannel(channelId: String, completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_MESSAGES + channelId, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                self.clearChannels()
                guard let data = response.data else { return }
                do {
                    if let json = try JSON(data: data).array {
                        for item in json {
                            let messageBody = item["messageBody"].stringValue
                            let channelId = item["channelId"].stringValue
                            let id = item["_id"].stringValue
                            let userName = item["userName"].stringValue
                            let userAvatar = item["userAvatar"].stringValue
                            let userAvatarColour = item["userAvatarColour"].stringValue
                            let timestamp = item["timeStamp"].stringValue
                            let message = Message(message: messageBody, userName: userName, channelId: channelId, userAvatar: userAvatar, userAvatarColour: userAvatarColour, id: id, timeStamp: timestamp)
                            self.messages.append(message)
                        }
                        completion(true)
                    } else {
                        debugPrint("Error trying to read data. Data was: \(data)")
                        completion(false)
                    }
                } catch {
                    debugPrint("Error trying to read data. Data was: \(data)")
                    completion(false)
                }
            } else {
                debugPrint(response.result.error as Any)
                completion(false)
            }
        }
    }
    
    func clearMessages() {
        messages.removeAll()
    }
}
