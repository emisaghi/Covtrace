import UIKit
import MapKit
import CoreLocation
class MapScreen: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var country: UILabel!
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
            locationManager.startUpdatingLocation()
              break
          case .authorizedWhenInUse:
             mapView.showsUserLocation = true
             centerView()
             locationManager.startUpdatingLocation()
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
          @unknown default:
            fatalError()
        }
    }
}

extension MapScreen: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else{return}
        let longitude = (location.coordinate.longitude)
        let latitude = (location.coordinate.latitude)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        let ceo: CLGeocoder = CLGeocoder()
        let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
        ceo.reverseGeocodeLocation(loc, completionHandler:
        {(placemarks, error) in
            if (error != nil)
            {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            }
            let pm = placemarks! as [CLPlacemark]
            if pm.count > 0 {
                        let pm = placemarks![0]
                let county = (pm.locality)
                self.country.text = county
            }
        }
    )
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
}

