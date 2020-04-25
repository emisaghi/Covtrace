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
    
    @IBOutlet var resetButton: [UIButton]!
    
    @IBOutlet var confirmationButton: [UIButton]!
    
    @IBOutlet var symptomButton: [UIButton]!
    
    @IBOutlet var statusButton: [UIButton]!
        
    @IBOutlet var confButton: [UIButton]!
    
    @IBOutlet var sympButtons: [UIButton]!
    
    @IBAction func status(_ sender: UIButton) {
        statusButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func confirmation(_ sender: UIButton) {
        confButton.forEach { (button) in
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
    
    enum Result: String {
        case positive = "positive"
        case negative = "negative/not tested"
    }
    
    enum sympResult: String {
        case yes = "yes"
        case no = "no"
    }
    
    enum confResult: String {
        case yes = "yes"
        case no = "no"
    }


    @IBAction func statusTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let status = Result(rawValue: title) else {
            return
        }
        switch status {
        case .positive:
            print("Hi")
            confirmationButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = !button.isHidden
                    self.view.layoutIfNeeded()
                })
            }
        case .negative:
            print("bye")
            symptomButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = !button.isHidden
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    
    @IBAction func confTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let confirmation = confResult(rawValue: title) else {
            return
        }
        switch confirmation {
        case .yes:
            print("ur positive")
        case .no:
            print("reset")
            resetButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = !button.isHidden
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    @IBAction func sympTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let symptoms = sympResult(rawValue: title) else {
            return
        }
        switch symptoms {
        case .yes:
            print("Hi")
            //give them testing criteria link
        default:
            print("bye")
            //give them negative link
        }
    }
    
}
