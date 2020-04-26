//
//  registerController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit
import Firebase




class registerController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var registerErrorLabel: UILabel!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailText.delegate = self
        self.passwordText.delegate = self
        // Do any additional setup after loading the view.
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func registerButtonTapped(_ sender: UIButton) {
        // validate email & password
        if emailText.hasText && passwordText.hasText {
            let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
            if registerController.isPasswordValid(cleanedPassword) {
            
                if let email = emailText.text, let password = passwordText.text {
            // register the user with firebase
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        
                        // check user isn't nil
                        if user != nil {
                            let vc = self.storyboard?.instantiateViewController(identifier: "mapController")
                            self.present(vc!, animated: true)
                        }
                        else {
                            self.registerErrorLabel.text = "There is already an account with this email or the email you entered is not supported. Please try again!"
                        }
                    }
                }
            }
            else {
                // Password isn't secure enough
                    self.registerErrorLabel.text = "Please ensure your password is at least 8 characters, contains a special character and a number."
            }
        }
        else {
            self.registerErrorLabel.text = "Please fill in all fields."
        }
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        let vcr = self.storyboard?.instantiateViewController(identifier: "logInController")
        self.present(vcr!, animated: true)
    }
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        registerErrorLabel.text = ""
    }
    
    
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        registerErrorLabel.text = ""
}
    
    
    static func isPasswordValid(_ password : String) -> Bool {
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }

}
