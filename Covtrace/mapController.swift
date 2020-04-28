//
//  mapController.swift
//  Covtrace
//
//  Created by Covtracers on 2020-04-13.
//  Copyright © 2020 Covtracer. All rights reserved.
//


import UIKit
import MapKit
import CoreLocation
class mapController: UIViewController{
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var County: UILabel!
    
    @IBOutlet weak var State: UILabel!
    @IBAction func dashboard(_ sender: Any) {
        self.performSegue(withIdentifier: "dashboardController", sender: self)
    }
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
    func getCenterLocation(for mapView: MKMapView) -> CLLocation {
        let latitude = mapView.centerCoordinate.latitude
        let longitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: longitude)
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
              break
          @unknown default:
            fatalError()
        }
    }
}

extension mapController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let middle = getCenterLocation(for: mapView)
        guard let location = locations.last else{return}
        let longitude = (location.coordinate.longitude)
        let latitude = (location.coordinate.latitude)
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let ceo: CLGeocoder = CLGeocoder()
            let loc: CLLocation = CLLocation(latitude: latitude, longitude: longitude)
            ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil)
                {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = (placemarks ?? nil) as [CLPlacemark]
                if pm.count > 0 {
                    let pm = placemarks![0]
                    let state = (pm.administrativeArea)
                    let county = (pm.subAdministrativeArea)
                    self.County.text = county
                    self.State.text = state
                    
                }
            }
        )
        guard middle.distance(from: location) > 50 else {return}
        let region = MKCoordinateRegion.init(center: center, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        let vc = segue.destination as! dashboardController
        vc.COUNTY = self.County.text!
        vc.STATE = self.State.text!
        
    }
}

