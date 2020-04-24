//
//  ViewController.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-12.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var signInSelector: UISegmentedControl!
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var phoneNumber: UITextField!
    
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var forgetpasswordButton: UIButton!
    @IBOutlet weak var selector: UISegmentedControl!

    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var noMatch: UILabel!
    
    var isSignIn:Bool = true
    var u = ""
    var user = ""
    
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func Keyboard(notification: Notification) {
        let userInfo = notification.userInfo!
        let keyboardScreenEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)
        if notification.name == Notification.NSNotification.Name.name.UIKeyboardWillHide {
            scrollView.contentInset = UIEdgeInsets.zero
        } else {
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height, right: 0)
        }
        scrollView.scrollIndicatorInsets = scrollView.contentInset
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return (true)
    }

    @IBAction func username(_ sender: Any) {
    }
    
    @IBAction func forgetPassword(_ sender: Any) {
        /*showTextInputPrompt(withMessage: "Email:") { [weak self] userPressedOK, email in
          guard let strongSelf = self, let email = email else {
            return
          }
          strongSelf.showSpinner {
            // [START password_reset]
            Auth.auth().sendPasswordReset(withEmail: email) { error in
              // [START_EXCLUDE]
              strongSelf.hideSpinner {
                if let error = error {
                  strongSelf.showMessagePrompt(error.localizedDescription)
                  return
                }
                strongSelf.showMessagePrompt("Sent")
              }
              // [END_EXCLUDE]
            }
            // [END password_reset]
          }
        }*/
    }
    
    @IBAction func signInSelectorChanged(_ sender: UISegmentedControl) {
        // flip the toggle
        isSignIn = !isSignIn
        
        // change label
        if isSignIn {
            signInLabel.text = "Sign In"
        }
        
        else {
            signInLabel.text = "Register"
        }
    }
    
    
    @IBAction func buttonText(_ sender: Any) {
        if (selector.selectedSegmentIndex == 0) {
            submitButton.setTitle("Sign In", for: .normal)
        }
        else {
            submitButton.setTitle("Register", for: .normal)
        }
    }
    
    @IBAction func submitButtonTapped(_ sender: UIButton) {
        // todo later: validate email & password
            
            if let email = emailText.text, let password = passwordText.text {
            // sign in or register the user
            if isSignIn {
                // sign in the user with firebase
                Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
                    // check user isn't nil
                    if user != nil {
                        // user is found, pass along the username & go to next screen
                        self.u = email
                        //self.performSegue(withIdentifier: "goToMap", sender: self)
                    
                        let vc = self.storyboard?.instantiateViewController(identifier: "MapScreen")
                        self.present(vc!, animated: true)
                        
                    }
                    
                    else {
                        self.noMatch.text = "Email or Password is incorrect"
                        // there is an error, show msg
                    }
                }
            }
            else {
                // register the user with firebase
                Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                    // check user isn't nil
                    if user != nil {
                        // user is found, pass along the username & go to next screen
                        self.u = email
                        self.performSegue(withIdentifier: "goToMap", sender: self)
                        
                    }
                    
                    else {
                        self.noMatch.text = "Email is already taken or password is less than 6 characters"
                    }
                }
            }
        }
    }

    /*
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // dismiss the keyboard when the veiw is tapped on
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
 */
    
}

