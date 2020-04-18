//
//  ChannelViewController.swift
//  Smack
//
//  Created by Chris Mercer on 13/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
        
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.userDataDidChange), name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ChannelViewController.updateChannelList), name: NOTIF_CHANNEL_DATA_DID_CHANGE, object: nil)
        
        SocketService.instance.getChannel { (success) in
            self.updateChannelList()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setupUserInfo()
    }
    
    func setupUserInfo() {
        if AuthService.instance.isLoggedIn {
            loginButton.setTitle(UserDataService.instance.name, for: .normal)
            avatarImageView.image = UIImage(named: UserDataService.instance.avatarName)
            avatarImageView.backgroundColor = UserDataService.instance.avatarColorAsUIColor()
            updateChannelList()
        } else {
            loginButton.setTitle("Login", for: .normal)
            avatarImageView.image = UIImage(named: "menuProfileIcon")
            avatarImageView.backgroundColor = UIColor.clear
        }
    }
    
    @objc func userDataDidChange(_ notif: Notification) {
        setupUserInfo()
    }
    
    @objc func updateChannelList() {
        if MessageService.instance.channels.count == 0 {
            MessageService.instance.findAllChannels { (success) in
                print("got channels")
            }
        }
        self.tableView.reloadData()
    }
    
    @IBAction func addChannelButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let addChannel = AddChannelViewController()
            addChannel.modalPresentationStyle = .custom
            present(addChannel, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        if AuthService.instance.isLoggedIn {
            let profile = ProfileViewController()
            profile.modalPresentationStyle = .custom
            present(profile, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: TO_LOGIN, sender: nil)
        }
    }
    
    @IBAction func prepareForUnwind(segue: UIStoryboardSegue) {}
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MessageService.instance.channels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "channelCell", for: indexPath) as? ChannelTableViewCell {
            let channel = MessageService.instance.channels[indexPath.row]
            cell.configureCell(channel: channel)
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let count = MessageService.instance.channels.count
        if  count == 0 || index >= count {
            MessageService.instance.findAllChannels { (success) in
                if !success {
                    return
                } else {
                    self.loadMessage(index: index)
                }
            }
        } else {
            loadMessage(index: index)
        }
    }
    
    func loadMessage(index: Int) {
        let channel = MessageService.instance.channels[index]
        MessageService.instance.selectedChannel = channel
        NotificationCenter.default.post(name: NOTIF_CHANNEL_SELECT, object: nil)
        self.revealViewController().revealToggle(animated: true)
    }
}
