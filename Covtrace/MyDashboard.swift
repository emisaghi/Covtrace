import UIKit
import SwiftCSV
class MyDashboard: UIViewController{
    

    
    var State = ""
    var county = ""
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackToMap", sender: self)
    }
    
    
    @IBAction func gotoProfile(_ sender: UIButton) {
        self.performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    @IBOutlet weak var link_url: UITextView!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        getlink()
        do {
            // From a file (with errors)
            let csvFile: CSV = try CSV(url: URL(fileURLWithPath: "path/to/users.csv"))
            } catch {
                // Catch errors from trying to load files
            }
   }
    var MD:[String:String] = ["Baltimore":"https://bao.arcgis.com/covid-19/jhu/county/24005.html"]
    var MA:[String:String] = [
    "Hampden":"https://bao.arcgis.com/covid-19/jhu/county/25013.html"]
    var PA:[String:String] = [
        "Bucks":"https://bao.arcgis.com/covid-19/jhu/county/42017.html", "Washington":"https://bao.arcgis.com/covid-19/jhu/county/42125.html"]
    var OR:[String:String] = [
     "Washington":"https://bao.arcgis.com/covid-19/jhu/county/41067.html"]
    
    func getlink(){
        if (State == "MD"){
        let text = "View details about county"
        let link = self.MD[self.county] ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "View details about county")
        link_url.attributedText = attributedString
        }
        if (State == "MA"){
        let text = "View details about county"
        let link = self.MA[self.county] ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "View details about county")
        link_url.attributedText = attributedString
        }
        if (State == "PA"){
        let text = "View details about county"
        let link = self.PA[self.county] ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "View details about county")
        link_url.attributedText = attributedString
        }
        if (State == "OR"){
        let text = "View details about county"
        let link = self.OR[self.county] ?? ""
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "View details about county")
        link_url.attributedText = attributedString
        }
        
    // Do any additional setup after loading the view.
    
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

