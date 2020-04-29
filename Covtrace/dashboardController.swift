//
//  dashboardController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit

class dashboardController: UIViewController{
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    
    var STATE = ""
    var COUNTY = ""
    @IBOutlet weak var county_label: UILabel!
    var positive = statusController();
    
    @IBOutlet weak var link_url: UITextView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        navigationBar.rightBarButtonItem = UIBarButtonItem(title:"Profile",
        style:.plain,
        target:self,
        action:#selector(goToProfile))
        
        navigationBar.leftBarButtonItem = UIBarButtonItem(title:"Map",
        style:.plain,
        target:self,
        action:#selector(backToMap))
        
        
        
        self.county_label.text = "My County:" + COUNTY + ", " + STATE
        
        //csv caller
        let csvfile:CSVCLASS = CSVCLASS()
        var link = ""
        link = csvfile.parseCSV(state: STATE, county: COUNTY)
        let text = "View details about county"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "View details about county")
        link_url.attributedText = attributedString
        
        
   }
    
    @objc func goToProfile() {
        self.performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    @objc func backToMap() {
        self.performSegue(withIdentifier: "goBackToMap", sender: self)
    }
    
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if (segue.identifier == "gotoProfile") {
        let vc = segue.destination as! statusController
        vc.County1 = COUNTY
        vc.State1 = STATE
    }
        if (segue.identifier == "goBackToMap") {
            let vc = segue.destination as! mapController
            vc.Countymap = COUNTY
            vc.Statemap = STATE
        }
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


