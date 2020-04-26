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
    
    @IBOutlet var testButton: [UIButton]!
    
    @IBOutlet var resButton: [UIButton]!

    @IBOutlet var resultButton: [UIButton]!
    
    @IBOutlet var sympButtons: [UIButton]!
    
    @IBOutlet var symptomButton: [UIButton]!
    
    @IBOutlet weak var url_link: UITextView!
    
    
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

    @IBAction func resetTapped(_ sender: UIButton) {
        testButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
        resButton.forEach { (button) in
            UIView.animate(withDuration: 0.3, animations: {
                button.isHidden = true
                self.view.layoutIfNeeded()
            })
        }
        resultButton.forEach { (button) in
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
    
    
    @IBAction func testTapped(_ sender: UIButton) {
        guard let title = sender.currentTitle, let test = testResult(rawValue: title) else {
        return
        }
        switch test {
        case .yes:
            print("Hi")
            resultButton.forEach { (button) in
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
        case .no:
            print("bye")
            symptomButton.forEach { (button) in
                UIView.animate(withDuration: 0.3, animations: {
                    button.isHidden = !button.isHidden
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
            resetButton.forEach { (button) in UIView.animate(withDuration: 0.3, animations: { button.isHidden = false
                self.view.layoutIfNeeded()
                })
            }
            positiveInfo()
        case .negative:
            print("reset")
            negativeInfo()
            resetButton.forEach { (button) in
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
        let link = "https://www.cdc.gov/coronavirus/2019-ncov/downloads/10Things.pdf"
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
        let vc = segue.destination as! dashboardController
        vc.COUNTY = County1
        vc.STATE = State1
    }
}

