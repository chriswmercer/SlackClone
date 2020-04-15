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
    }

    @IBAction func exitButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: UNWIND_TO_CHANNEL, sender: nil)
    }
    
    @IBAction func createAccountButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text, usernameTextField.text != "" else { return }
        guard let email = emailTextField.text , emailTextField.text != "" else { return }
        guard let password = passwordTextField.text, passwordTextField.text != "" else { return }
        
        self.showSpinner(onView: self.view)
        
        /*
        AuthService.instance.registerUser(email: email, password: password) { (success) in
            self.removeSpinner()
            if success {
                print("registered user")
                AuthService.instance.loginUser(email: email, password: password) { (success) in
                    print("user logged in")
                }
            }
        }
         */
        AuthService.instance.createAccount(email: email, password: password, username: username) { (success) in
            self.removeSpinner()
            if success {
                print("User created and logged in")
            } else {
                
            }
        }
    }
    
    @IBAction func chooseAvatarButtonPressed(_ sender: Any) {
    }
    
    @IBAction func generateBackgrouncColourPressed(_ sender: Any) {
    }
}
