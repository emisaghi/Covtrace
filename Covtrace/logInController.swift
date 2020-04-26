//
//  logInController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit
import Firebase

class logInController: UIViewController, UITextFieldDelegate {


    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var forgotPasswordButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInErrorLabel: UILabel!
    /*
    @IBAction func signin(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailText.delegate = self
        self.passwordText.delegate = self
        // Do any additional setup after loading the view.
//        NotificationCenter.default.addObserver(self, selector: #selector(Keyboard(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }

//    @objc func Keyboard(notification: Notification) {
//        let userInfo = notification.userInfo!
//        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
//        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
//        if notification.name == UIResponder.keyboardWillHideNotification {
//            scrollView.contentInset = UIEdgeInsets.zero
//        } else {
//            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
//        }
//        scrollView.scrollIndicatorInsets = scrollView.contentInset
//    }
//
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        // dismiss the keyboard when the veiw is tapped on
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        if emailText.hasText {
            if let email = emailText.text {
                Auth.auth().sendPasswordReset(withEmail: email) { error in
                  if error != nil {
                    self.signInErrorLabel.text = "There was an error in resetting your password!"
                  }
                  else {
                    self.signInErrorLabel.text = "Reset email sent successfully. Please check your email."
                  }
                }
            }
        }
        else {
            signInErrorLabel.text = "Please enter your email and then tap \"forgot password\""
        }
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vcr = self.storyboard?.instantiateViewController(identifier: "registerController")
        self.present(vcr!, animated: true)
    }
    
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        // todo later: validate email & password
        if emailText.hasText && passwordText.hasText {
            // sign in the user with firebase
            if let email = emailText.text, let password = passwordText.text {
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // check user isn't nil
                    if user != nil {
                        // user is found
                        //self.performSegue(withIdentifier: "goToMap", sender: self)
                    
                        let vcm = self.storyboard?.instantiateViewController(identifier: "mapController")
                        self.present(vcm!, animated: true)
                        
                    }
                    
                    else {
                        // there is an error, show msg
                        self.signInErrorLabel.text = "Email or Password is incorrect"
                    }
                }
            }
        }
        else {
            self.signInErrorLabel.text = "Please fill in all fields."
        }
    }
    
    
    @IBAction func emailTextChanged(_ sender: UITextField) {
        signInErrorLabel.text = ""
    }
    
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        signInErrorLabel.text = ""
    }
    
    
    
        }
