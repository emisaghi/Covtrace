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
        link_url.layer.cornerRadius = 20
        link_url.textColor = UIColor.white
    
        self.county_label.text = COUNTY + ", " + STATE
        //csv caller
        let csvfile:CSVCLASS = CSVCLASS()
        var link = ""
        link = csvfile.parseCSV(state: STATE, county: COUNTY)
        let text = "County Details"
        let attributedString = NSAttributedString.makeHyperlink(for: link, in: text, as: "County Details")
        link_url.attributedText = attributedString
        textViewDidChange(link_url)
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(PPKController.myPeerID())
        docRef.getDocument(source: .cache) { (document, error) in
            if let document = document {
                self.property = document.get("userID") as! String
                print(self.property)//other users PeerID
            } else {
                print("Document does not exist in cache")
            }
        }
        /*Can't access other ppl's info or it crashes
        let docRefe = db.collection("users").document(self.property)
        docRefe.getDocument(source: .cache) { (document, error) in
            if let document = document {
                let STATUS = document.get("status") as! String
                print(STATUS)
            } else {
                print("Document does not exist in cache")
            }
 
    }
 */
    }
    @objc func goToProfile() {
        self.performSegue(withIdentifier: "gotoProfile", sender: self)
    }
    
    @objc func backToMap() {
        self.performSegue(withIdentifier: "goBackToMap", sender: self)
    }
    
    func textViewDidChange(_ textView: UITextView) { textView.textAlignment = .center }
    
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


