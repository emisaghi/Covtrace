import UIKit
import MapKit
import CoreLocation
class MapScreen: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var address: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
    }
    func setUpLocationManager(){
        locationManager.delegate=self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    func checkLocationServices(){
        if CLLocationManager.locationServicesEnabled(){
            setUpLocationManager()
            checkLocationAuthorization()
        }else{
            //
        }
    }
    func centerView(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 1000, longitudinalMeters: 1000)
            mapView.setRegion(region, animated: true)
        }
    }
    func checkLocationAuthorization(){
          switch CLLocationManager.authorizationStatus(){
          case .authorizedAlways:
            mapView.showsUserLocation = true
            centerView()
              break
          case .authorizedWhenInUse:
             mapView.showsUserLocation = true
             centerView()
              //recommend to keep it on all the time and do map
              break
          case .denied:
              //tell them to turn it on
              break
          case .notDetermined:
              locationManager.requestAlwaysAuthorization()
              break
          case .restricted:
              //show alert
              break
          }
    }
}

extension MapScreen: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        print(location.coordinate.longitude)
        print(location.coordinate.latitude)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        //
    }
}

