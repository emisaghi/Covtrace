//
//  statusController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit



class statusController: UIViewController {
    
    @IBAction func BackDash(_ sender: Any) {
    self.performSegue(withIdentifier: "BackToDashboard", sender: self)
           }
    
    var State1 = ""
    var County1 = ""
    
    @IBOutlet var resetButton: [UIButton]!
    
    @IBOutlet var confirmationButton: [UIButton]!
    
    @IBOutlet var symptomButton: [UIButton]!
    
    @IBOutlet var statusButton: [UIButton]!
        
    @IBOutlet var confButton: [UIButton]!
    
    @IBOutlet var sympButtons: [UIButton]!
    
    @IBOutlet weak var url_link: UITextView!
    
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

    @IBAction func resetTapped(_ sender: UIButton) {
        statusButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        confirmationButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
        confButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
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
        case .negative:
            print("bye")
            symptomButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = !button.isHidden
                    self.view.layoutIfNeeded()
                })
            }
            confirmationButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
                    self.view.layoutIfNeeded()
                })
            }
            confButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = true
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
            resetButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            positiveInfo()
        case .no:
            print("reset")
            resetButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
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
            resetButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = false
                    self.view.layoutIfNeeded()
                })
            }
            symptomInfo()
            //give them testing criteria link
        default:
            print("bye")
            resetButton.forEach { (button) in
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
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/coronavirus/2019-ncov/downloads/sick-with-2019-nCoV-fact-sheet.pdf"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    
    func negativeInfo(){
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/coronavirus/2019-ncov/prevent-getting-sick/prevention.html"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    func symptomInfo(){
        let text = "Please read the following information"
        let link = "https://www.cdc.gov/publichealthgateway/healthdirectories/healthdepartments.html"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "Please read the following information")
        url_link.attributedText = attributedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! MyDashboard
        vc.COUNTY = County1
        vc.STATE = State1
    }
}
