//
//  ChatViewController.swift
//  Smack
//
//  Created by Chris Mercer on 13/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var menuButton: UIButton!
    @IBOutlet weak var smackText: UILabel!
    @IBOutlet weak var messageTextBox: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var typingUsersLabel: UILabel!
    
    var isTyping = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        
        //hook up button
        menuButton.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)), for: .touchUpInside)
        self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        self.view.addGestureRecognizer(self.revealViewController().tapGestureRecognizer())
        
        //set up keyboard
        view.bindToKeyboard()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ChatViewController.handleTap))
        view.addGestureRecognizer(tap)
        sendButton.isHidden = true
        
        self.updateText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.channelSelected), name: NOTIF_CHANNEL_SELECT, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChatViewController.messageAdded), name: NOTIF_MESSAGE_ADDED, object: nil)
        
        if AuthService.instance.isLoggedIn {
            AuthService.instance.wakeUser { (sucecss) in
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
            }
            
            MessageService.instance.findAllChannels { (success) in
                NotificationCenter.default.post(name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
            }
            
            SocketService.instance.getMessage { (message) in
                guard let channelId = MessageService.instance.selectedChannel?.id else { return }
                guard let messageChannelId = message.channelId else { return }
                
                if channelId == messageChannelId {
                    MessageService.instance.messages.append(message)
                    NotificationCenter.default.post(name: NOTIF_MESSAGE_ADDED, object: nil)
                } else {
                    MessageService.instance.unreadChannels.append(messageChannelId)
                    NotificationCenter.default.post(name: NOTIF_MESSAGE_ADDED_DIFFERENT_CHANNEL, object: nil)
                }
            }
        }
        
        SocketService.instance.getTypingUsers { (typingUsers) in
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            var names = ""
            var numberOfTypes = 0
            for (typingUser, channel) in typingUsers {
                if typingUser != UserDataService.instance.name && channel == channelId {
                    if names == "" {
                        names = typingUser
                    } else {
                        names = "\(names), \(typingUser)"
                    }
                    numberOfTypes += 1
                }
            }
            if AuthService.instance.isLoggedIn && numberOfTypes > 0 {
                let verb = numberOfTypes > 1 ? "are" : "is"
                self.typingUsersLabel.text = "\(names) \(verb) typing a message"
            } else {
                self.typingUsersLabel.text = ""
            }
        }
    }
        
    @IBAction func sendMessagePressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            guard let channelId = MessageService.instance.selectedChannel?.id else { return }
            guard let message = messageTextBox.text else { return }
            SocketService.instance.addMessage(messageBody: message, userId: UserDataService.instance.id, channelId: channelId) { (success) in
                if success {
                    self.messageTextBox.text = ""
                    self.messageTextBox.resignFirstResponder()
                    SocketService.instance.stopTyping(username: UserDataService.instance.name, channelId: channelId)
                }
            }
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        updateText()
        
        if AuthService.instance.isLoggedIn {
            onLoginGetMessages()
        }
    }
    
    @objc func channelSelected(_ notif: Notification) {
        updateWithChannel()
    }
    
    @objc func messageAdded(_ notif: Notification) {
        self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
        self.tableView.reloadData()
    }
    
    @objc func handleTap() {
        view.endEditing(true)
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
        getMessages()
    }
    
    func onLoginGetMessages() {
        MessageService.instance.findAllChannels { (success) in
            if success {
                if MessageService.instance.channels.count > 0 {
                    MessageService.instance.selectedChannel = MessageService.instance.channels[0]
                    self.updateWithChannel()
                } else {
                    self.smackText.text = "Smack - No Channels Yet!"
                }
            }
        }
    }
    
    func getMessages() {
        guard let channelId = MessageService.instance.selectedChannel?.id else { return }
        MessageService.instance.findAllMessagesForChannel(channelId: channelId) { (success) in
            if success {
                self.tableView.setContentOffset(CGPoint(x: 0, y: CGFloat.greatestFiniteMagnitude), animated: true)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "messageCell", for: indexPath) as? MessageTableViewCell {
            let message = MessageService.instance.messages[indexPath.row]
            cell.configureCell(message: message)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    @IBAction func messageBoxEditing(_ sender: Any) {
        if messageTextBox.text == "" {
            isTyping = false
            sendButton.isHidden = true
            SocketService.instance.stopTyping(username: UserDataService.instance.name, channelId: MessageService.instance.selectedChannel!.id)
        } else {
            if isTyping == false {
                sendButton.isHidden = false
                SocketService.instance.startTyping(username: UserDataService.instance.name, channelId: MessageService.instance.selectedChannel!.id)
            }
            isTyping = true
        }
    }
}
