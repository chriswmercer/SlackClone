//
//  ChannelTableViewCell.swift
//  Smack
//
//  Created by Chris Mercer on 17/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class ChannelTableViewCell: UITableViewCell {
    
    @IBOutlet weak var channelName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected {
            channelName.font = UIFont(name:"HelveticaNeue-Bold", size: 17.0)
        } else {
            channelName.font = UIFont(name:"HelveticaNeue", size: 17.0)
        }
    }
    
    func configureCell(channel: Channel) {
        var title = channel.title
        if !title.starts(with: "#") {
            title = "#\(title)"
        }
        channelName.text = title
    }

}
