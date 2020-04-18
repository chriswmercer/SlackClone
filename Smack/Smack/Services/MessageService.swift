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
    
    func findAllChannels(completion: @escaping CompletionHandler) {
        Alamofire.request(URL_GET_CHANNELS, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: bearerHeader).responseJSON { (response) in
            if response.result.error == nil {
                guard let data = response.data else { return }
                do
                {
                    if let json = try JSON(data: data).array {
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
        channels = [Channel]()
    }
}
