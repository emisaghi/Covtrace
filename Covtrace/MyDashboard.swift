import UIKit

class MyDashboard: UIViewController{
    
    @IBAction func goBack(_ sender: Any) {
        self.performSegue(withIdentifier: "goBackToMap", sender: self)
    }

override func viewDidLoad() {
       super.viewDidLoad()

       // Do any additional setup after loading the view.
   }
}
