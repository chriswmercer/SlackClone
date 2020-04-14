//
//  ChannelViewController.swift
//  Smack
//
//  Created by Chris Mercer on 13/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class ChannelViewController: UIViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.revealViewController()?.rearViewRevealWidth = self.view.frame.size.width - 60
    }
    
    @IBAction func addChannelButtonPressed(_ sender: Any) {
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
    }
}
