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
    @IBOutlet weak var confirmPass: UITextField!
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailText.delegate = self
        self.passwordText.delegate = self
        self.confirmPass.delegate = self
        registerButton.layer.cornerRadius = 20
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
        if emailText.hasText && passwordText.hasText && confirmPass.hasText {
            let cleanedPassword = passwordText.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let cleanedConfirmPassword = confirmPass.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if (cleanedConfirmPassword != cleanedPassword){
            self.registerErrorLabel.text = "Passwords don't match"
            }
            else {
                if registerController.isPasswordValid(cleanedPassword) {

                    if let email = emailText.text, let password = passwordText.text {
                // register the user with firebase
                        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                            
                            // check user isn't nil
                            if user != nil {
                                /* var actionCodeSettings =  ActionCodeSettings.init()
                                actionCodeSettings.handleCodeInApp = true
                                actionCodeSettings.url =
                                    URL(string: "https://covtrace.page.link/?email=%@", email)
                                user?.user.sendEmailVerification(with: actionCodeSettings, completion: { error in
                                    
                                })
                                let vc = self.storyboard?.instantiateViewController(identifier: "mapController")
                                self.present(vc!, animated: true)*/
                                
                                user?.user.sendEmailVerification(completion: { (error) in
                                    if error == nil {
                                        self.registerErrorLabel.text = "Verification email sent. Please verify your email by clicking on the link sent to your email and then log in to the app!"
                                    }
                                    else {
                                        self.registerErrorLabel.text = "There was an error sending the verification email! Please try again!"
                                    }
                                })
                            }
                            else {
                                self.registerErrorLabel.text = "There is already an account with this email or the email you entered is not supported. Please try again!"
                            }
                        }
                    }
                }
                else {
                    // Password isn't secure enough
                        self.registerErrorLabel.text = "Please ensure your password is at least 8 characters, contains an uppercase, a lower case and a number."
                }
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
        
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}")
        return passwordTest.evaluate(with: password)
    }

}
