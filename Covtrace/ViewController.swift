//
//  ViewController.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-12.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    
    @IBOutlet weak var signInSelector: UISegmentedControl!
    
    @IBOutlet weak var signInLabel: UILabel!
    
    @IBOutlet weak var emailText: UITextField!
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var isSignIn:Bool = true
    var u = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    
                }
                
                else {
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
                    self.performSegue(withIdentifier: "goToHome", sender: self)
                    
                }
                
                else {
                    // there is an error, show msg
                }
                }
        }
        }
        }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // dismiss the keyboard when the veiw is tapped on
        emailText.resignFirstResponder()
        passwordText.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! ViewController2
        vc.user = self.u
        
    }
    
    
    }

