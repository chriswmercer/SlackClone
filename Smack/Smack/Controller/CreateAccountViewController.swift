//
//  CreateAccountViewController.swift
//  Smack
//
//  Created by Chris Mercer on 15/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var avatarImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, usernameTextField.text != "" else { return }
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            if success {
                print("registered user")
            }
        }
    }
    
    @IBAction func chooseAvatarButtonPressed(_ sender: Any) {
    }
    
    @IBAction func generateBackgrouncColourPressed(_ sender: Any) {
    }
}
