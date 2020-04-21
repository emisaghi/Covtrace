//
//  ViewController2.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-13.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit

class ViewController2: UIViewController {

    @IBOutlet weak var welcomeMsg: UILabel!
    
    var user = ""
    
    
    @IBAction func signin(_ sender: UIButton) {
        self.performSegue(withIdentifier: "goToSignIn", sender: self)
    }
    
    
    @IBAction func register(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoRegister", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        welcomeMsg.text = user
    }
    
    @IBAction func next(_ sender: Any) {
        self.performSegue(withIdentifier: "goToMap", sender: self)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
