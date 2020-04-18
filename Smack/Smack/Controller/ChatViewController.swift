//
//  ChatViewController.swift
//  Smack
//
//  Created by Chris Mercer on 13/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var menuButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hook up button
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.wakeUser { (sucecss) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
            
            MessageService.instance.findAllChannels { (success) in
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            }
        }
    }
}
