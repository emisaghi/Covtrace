//
//  statusController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class statusController: UIViewController {
    var ref = Database.database().reference()
    var State1 = ""
    var County1 = ""
    var positive = false
    var tempPositive = false
    var userID = PPKController.myPeerID()
    var numPositive = 0
    var numUsers = 0
    @IBOutlet weak var navigationBar: UINavigationItem!

    @IBOutlet var submitButton: [UIButton]!
    
    @IBOutlet var testButton: [UIButton]!
    
    @IBOutlet var resButton: [UIButton]!

    @IBOutlet var resultButton: [UIButton]!
    
    @IBOutlet var sympButtons: [UIButton]!
    
    @IBOutlet var symptomButton: [UIButton]!
    
    @IBOutlet weak var url_link: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.rightBarButtonItem = UIBarButtonItem(title:"Sign Out",
        style:.plain,
        target:self,
        action:#selector(signOut))
        
        navigationBar.leftBarButtonItem = UIBarButtonItem(title:"My Dashboard",
        style:.plain,
        target:self,
        action:#selector(backToDashboard))
        textViewDidChange(url_link)
        submitButton.forEach { $0.layer.cornerRadius = 10 }
        print (userID+"hello")
    }

    
    @objc func signOut() {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print ("Error signing out: %@", signOutError)
        }
        let def = UserDefaults.standard
        def.set(false, forKey: "userSignedIn")
        def.synchronize()
        let vcm = self.storyboard?.instantiateViewController(identifier: "logInController")
        self.present(vcm!, animated: true)
            print("signed out")
    }
    func textViewDidChange(_ textView: UITextView) { textView.textAlignment = .center }
    
    @objc func backToDashboard() {
        self.performSegue(withIdentifier: "BackToDashboard", sender: self)
    }

/*
    @objc func handleSignoutButtonTapped() {
        let signoutAction = UIAlertAction(title: "Sign Out", style: .destructive) { (action) in
            do {
                try Auth.auth().signOut()
                let login = logInController()
                let welcomeNavController = UINavigationController(rootViewController: login)
                self.present(welcomeNavController, animated: true, completion: nil)
            } catch let err as NSError {
                print("Failed to sign out with error", err)
                print (err.localizedDescription)
                //Service.showAlert(on: self, style: .alert, title: "Sign Out Error", message: err.localizedDescription)
            }
        }
        //Service.showAlert(on: self, style: .actionSheet, title: nil, message: nil, actions: [signoutAction], completion: nil)

    } */
    
    @IBAction func test(_ sender: UIButton) {
        testButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    
    @IBAction func res(_ sender: UIButton) {
        resButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func symptoms(_ sender: UIButton) {
        sympButtons.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum testResult: String {
        case yes = "yes"
        case no = "no"
    }
    
    enum statusResult: String {
        case positive = "positive"
        case negative = "negative"
    }
    
    enum symptomResult: String {
        case yes = "yes"
        case no = "no"
    }
    

    @IBAction func submitButtonTapped(_ sender: UIButton) {
        print(positive)
        let alert = UIAlertController(title: "Confirm Data", message: "You're data is going to be updated.", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Cancel", style: .cancel, handler: {(action) in print("Cancel")
        })
        let action2 = UIAlertAction(title: "Confirm", style: .default, handler: {(action) in print("Confirm")
            self.positive = self.tempPositive
            if (self.positive == true){
                let db = Firestore.firestore()
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                let datetime = formatter.string(from: Date())
                db.collection("users").document(PPKController.myPeerID()).setData(["date_time": datetime, "status": "positive"], merge: true)
            }else{
                let db = Firestore.firestore()
                let formatter = DateFormatter()
                formatter.dateStyle = .short
                formatter.timeStyle = .short
                let datetime = formatter.string(from: Date())
                db.collection("users").document(PPKController.myPeerID()).setData([ "date_time": datetime, "status": "negative"], merge: true)
            }
        })
        alert.addAction(action1)
        alert.addAction(action2)
        self.present(alert, animated: true)

    }
    
    @IBAction func testTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let test = testResult(rawValue: title) else {
        return
        }
        switch test {
        case .yes:
            print("Hi")
            resultButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            symptomButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
            sympButtons.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
        case .no:
            print("bye")
            symptomButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            resultButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
            resButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    
    @IBAction func statTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let res = statusResult(rawValue: title) else {
            return
        }
        switch res {
        case .positive:
            print("ur positive")
            tempPositive = true
            submitButton.forEach { (button) in UIView.animate(withDuration: 0.3, animations: { button.isHidden = false
                self.view.layoutIfNeeded()
                })
            }
            positiveInfo()
        case .negative:
            print("reset")
            tempPositive = false
            negativeInfo()
            submitButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    @IBAction func symptomTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let symptoms = symptomResult(rawValue: title) else {
            return
        }
        switch symptoms {
        case .yes:
            print("Hi")
            tempPositive = false
            submitButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            symptomInfo()
            //give them testing criteria link
        default:
            print("bye")
            tempPositive = false
            submitButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            negativeInfo()
            //give them negative link
            
        }
    }
    
    
    func positiveInfo(){
//        self.url_link.text = "Please read the following information"
        url_link.isHidden = false
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/coronavirus/2019-ncov/downloads/10Things.pdf"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    
    func negativeInfo(){
        url_link.isHidden = false
//        self.url_link.text = "Please read the following information"
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/coronavirus/2019-ncov/prevent-getting-sick/prevention.html"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    func symptomInfo(){
        url_link.isHidden = false
//        self.url_link.text = "Please read the following information"
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/publichealthgateway/healthdirectories/healthdepartments.html"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! dashboardController
        vc.COUNTY = County1
        vc.STATE = State1
        vc.numPositive = self.numPositive
        vc.numUsers = self.numUsers
    }
}
