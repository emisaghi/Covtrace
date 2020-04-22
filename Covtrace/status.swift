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
    
    @IBAction func yes1(_ sender: UIButton) {
        question2.text = "what are your results?"
    }
    
    @IBAction func no1(_ sender: UIButton) {
        question2.text = "are you experiencing cough, fever, or shortness of breath?"
    }
    /*
    @IBAction func AddButton(_ sender: AnyObject) {
        if let user = user {
        self.performSegue(withIdentifier: "AddDevice", sender: nil)
         }
        else {
        let alert = UIAlertController(title: "Sorry", message:"You have to Register First", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default) { _ in })
        self.present(alert, animated: true){}
        }
     }
 */
}

