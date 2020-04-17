//
//  LoginViewController.swift
//  Smack
//
//  Created by Chris Mercer on 14/04/2020.
//  Copyright © 2020 Chris Mercer. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func exitButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func loginButtonPressed(_ sender: Any) {
        guard let username = usernameTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        errorLabel.isHidden = true
        self.showSpinner(onView: self.view)
        
        AuthService.instance.login(email: username, password: password) { (success) in
            if success {
                NotificationCenter.default.post(name: NOTIF_USER_DATA_DID_CHANGE, object: nil)
                self.dismiss(animated: true, completion: nil)
            } else {
                self.errorLabel.isHidden = false
            }
        }
        self.removeSpinner()
    }
    
    @IBAction func signupButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: TO_CREATE_ACCOUNT, sender: nil)
    }
}
