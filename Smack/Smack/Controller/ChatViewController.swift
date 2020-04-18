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
    @IBOutlet weak var smackText: UILabel!
    
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hook up button
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        self.updateText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected), name: NOTIF_CHANNEL_SELECT, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.wakeUser { (sucecss) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
            
            MessageService.instance.findAllChannels { (success) in
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        updateText()
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    func updateText() {
        if AuthService.instance.isLoggedIn {
            smackText.text = "Smack"
        } else {
            smackText.text = "Smack - Please Login"
        }
    }
    
    func updateWithChannel() {
        let channelName = MessageService.instance.selectedChannel?.title ?? ""
        smackText.text = "Smack - #\(channelName)"
    }
}
