//
//  ViewController2.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-13.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit



class status: UIViewController {
    
    @IBAction func BackDash(_ sender: Any) {
        
               self.performSegue(withIdentifier: "BackToDashboard", sender: self)
           }
    
    @IBOutlet weak var question2: UILabel!
    
    
    @IBOutlet var statusButton: [UIButton]!
    
    @IBOutlet var confirmationButton: [UIButton]!
    
    @IBAction func status(_ sender: UIButton) {
        statusButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func confirmation(_ sender: UIButton) {
        confirmationButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    enum Result: String {
        case positive = "positive"
        case negative = "negative/not tested"
    }
    
    enum Confresult: String {
        case yes = "yes"
        case no = "no"
    }
    
    @IBAction func yes1(_ sender: UIButton) {
        question2.text = "please confirm that you are tested + for covid-19"
    }
    
    @IBAction func no1(_ sender: UIButton) {
        question2.text = "are you experiencing cough, fever, or shortness of breath?"
    }
    
    @IBAction func statusTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let status = Result(rawValue: title) else {
            return
        }
        switch status {
        case .positive:
            print("Hi")
        default:
            print("bye")
        }
    }
    
    @IBAction func confirmationTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let confirmation = Confresult(rawValue: title) else {
            return
        }
        switch confirmation {
        case .yes:
            print("Hi")
        default:
            print("bye")
        }
    }
    
}
