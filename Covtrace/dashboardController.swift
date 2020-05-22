// Created by Covtrace on 2020-04-13.
// Copyright © 2020 Covtrace. All rights reserved.
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.

// dashboardController.swift
// Covtrace

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class dashboardController: UIViewController{
    var ref = Database.database().reference()
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    var STATE = ""
    var COUNTY = ""
    var date = ""
    var property = ""
    var numPositive = 0
    var numUsers = 0
    @IBOutlet weak var county_label: UILabel!
    var positive = statusController();
    
    @IBOutlet weak var link_url: UITextView!
    @IBOutlet weak var numberUsers: UILabel!
    @IBOutlet weak var NumberPositive: UILabel!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        var strArray = COUNTY.components(separatedBy: ", ")
        var county = strArray[0]
        var STATE = strArray[1]
        print(county + "hi" + STATE)
        if (numPositive == 0 && numUsers == 0){
            getPositive()
        }else{
            self.NumberPositive.text = String(self.numPositive) + " Tested Positive"
            self.numberUsers.text = String(self.numUsers) + " Users"
        }
        navigationBar.rightBarButtonItem = UIBarButtonItem(title:"Profile",
        style:.plain,
        target:self,
        action:#selector(goToProfile))
        
        navigationBar.leftBarButtonItem = UIBarButtonItem(title:"Map",
        style:.plain,
        target:self,
        action:#selector(backToMap))
        link_url.layer.cornerRadius = 20
        self.county_label.text = COUNTY
        //csv caller
        let csvfile:CSVCLASS = CSVCLASS()
        var link = ""
        link = csvfile.parseCSV(state: STATE, county: county)
        let text = "County Details"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "County Details")
        link_url.attributedText = attributedString
        textViewDidChange(link_url)
    }
    
    @IBAction func updateNum(_ sender: UIButton) {
        getPositive()
    }
    
    @objc func goToProfile() {
        self.performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    @objc func backToMap() {
        self.performSegue(withIdentifier: "goBackToMap", sender: self)
    }
    
    func textViewDidChange(_ textView: UITextView) { textView.textAlignment = .center }
    
    /*func getPositive(){
        var property = ""
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(PPKController.myPeerID())
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                property = document.get("userID") as! String
                print(property)//other users PeerID
            } else {
                print("Document does not exist in cache")
            }
        }
        
        let seconds = 10.0
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            let docRefe = db.collection("users").document(property)
                docRefe.getDocument(source: .server) { (document, error) in
                    if let document = document {
                        let STATUS = document.get("status") as! String
                        print(STATUS)
                        if (STATUS == "positive"){
                            self.numPositive += 1
                        }
                        self.numUsers += 1
                    } else {
                        print("Document does not exist in cache")
                    }

            }
        }
    }*/
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "gotoProfile") {
        let vc = segue.destination as! statusController
        vc.County1 = COUNTY
        vc.State1 = STATE
        vc.numPositive = self.numPositive
        vc.numUsers = self.numUsers
            }
        if (segue.identifier == "goBackToMap") {
            let vc = segue.destination as! mapController
            vc.Countymap = COUNTY
            vc.Statemap = STATE
            vc.numPositive = self.numPositive
            vc.numUsers = self.numUsers
        }
}
        func getPositive(){
            self.numPositive = 0
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(PPKController.myPeerID()).collection("all-contacts")
           docRef.getDocuments { (snapshot, error) in
                // [START_EXCLUDE]
                if error != nil {
                    print("error", error!)
                }
                else {
                    print(snapshot?.documents.count ?? 0)
                    self.numUsers = snapshot?.documents.count ?? 0
                    for document in snapshot!.documents {
                        print(document.documentID)
                        //let seconds = 0.001
                        //DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                            var STATUS = ""
                            let docRefe = db.collection("users").document(document.documentID)
                                docRefe.getDocument(source: .server) { (document, error) in
                                    if let document = document {
                                        STATUS = document.get("status") as? String ?? "none"
                                        print(STATUS)
                                        if (STATUS == "positive"){
                                            self.numPositive += 1
                                        }
                                    } else {
                                        print("Document does not exist in cache")
                                    }

                            }
                        
                        // print(self.numPositive)
                    //}
                }
                // [END_EXCLUDE]
            }
            let seconds = 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            print(self.numPositive)
            self.NumberPositive.text = String(self.numPositive) + " Tested Positive"
            self.numberUsers.text = String(self.numUsers) + " Users"
            }
            }
            //        docRef.whereField("status", isEqualTo: "positive")
    //            .getDocuments() { (querySnapshot, err) in
    //                if let err = err {
    //                    print("Error getting documents: \(err)")
    //                } else {
    //                    for document in querySnapshot!.documents {
    //                        print("\(document.documentID) => \(document.data())")
    //                    }
    //                }
    //        }
            // let docRef = db.collection("users").document(PPKController.myPeerID())
            
    //        docRef.getDocument(source: .server) { (document, error) in
    //            if let document = document {
    //                property = document.get(PPKController.myPeerID()) as? String ?? "none"
    //                print (PPKController.myPeerID())
    //                print(property)//other users PeerID
    //            } else {
    //                property = "none"
    //                print("Document does not exist in cache")
    //            }
    //        }
    //        test: if property == "none"{
    //            break test
    //        }else{

    //            }
    //        }
        }
    
}

extension NSAttributedString{
    static func makeHyperlink(for path: String, in string: String, as substring: String) ->NSAttributedString{
        let nsString = NSString(string: string)
        let subStringRange = nsString.range(of: substring)
        let attributedString = NSMutableAttributedString(string: string)
        attributedString.addAttribute(.link, value: path, range: subStringRange)
        return attributedString
    }
}


