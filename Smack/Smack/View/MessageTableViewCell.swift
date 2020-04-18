//
//  MessageTableViewCell.swift
//  Smack
//
//  Created by Chris Mercer on 18/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImage: CircleImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(message: Message) {
        messageLabel.text = message.message
        usernameLabel.text = message.userName
        //timestampLabel.text = message.timeStamp
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = componentStringToUIColour(components: message.userAvatarColour)
    }
}
