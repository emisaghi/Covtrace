//
//  ViewController2.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-13.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit



class status: UIViewController {
    
    @IBOutlet weak var question2: UILabel!
    
    @IBOutlet var statusButton: [UIButton]!
    
    @IBAction func status(_ sender: UIButton) {
        statusButton.forEach { (button) in
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
    
    
}
