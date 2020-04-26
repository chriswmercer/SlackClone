//
//  MessageModel.swift
//  Smack
//
//  Created by Chris Mercer on 18/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import Foundation

struct Message {
    public private(set) var message: String!
    public private(set) var userName: String!
    public private(set) var channelId: String!
    public private(set) var userAvatar: String!
    public private(set) var userAvatarColour: String!
    public private(set) var id: String!
    public private(set) var timeStamp: String!
}
