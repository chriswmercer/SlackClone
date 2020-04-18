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
}
