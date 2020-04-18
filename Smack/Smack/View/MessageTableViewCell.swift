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
        userImage.image = UIImage(named: message.userAvatar)
        userImage.backgroundColor = componentStringToUIColour(components: message.userAvatarColour)
        
        if let datetime = message.timeStamp {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            if let date = dateFormatter.date(from: datetime) {
                dateFormatter.dateFormat = "dd-MMM, HH:mm:ss"
                let formattedDate = dateFormatter.string(from: date)
                timestampLabel.text = "\(formattedDate)"
            } else {
                timestampLabel.text = "\(datetime)"
            }
        }
    }
}
