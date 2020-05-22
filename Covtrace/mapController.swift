// Created by Covtrace on 2020-04-13.
// Copyright © 2020 Covtrace. All rights reserved.
// This file is subject to the terms and conditions defined in
// file 'LICENSE.txt', which is part of this source code package.

// mapController.swift
// Covtrace



import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseAuth
import FirebaseDatabase
class mapController: UIViewController{
    var Countymap = ""
    var Statemap =  ""
    var numUsers = 0
    var numPositive = 0
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var County: UILabel!
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        checkLocationServices()
        navigationBar.rightBarButtonItem = UIBarButtonItem(title:"My Dashboard",
        style:.plain,
        target:self,
        action:#selector(goToDashboard))
    }
    
    @objc func goToDashboard() {
                self.performSegue(withIdentifier: "goToDashboard", sender: self)
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
                let pm = placemarks as [CLPlacemark]?
                if (pm != nil){
                    if pm?.count ?? 0 > 0 {
                    let pm = placemarks![0]
                    let Statemap = (pm.administrativeArea)
                    let Countymap = (pm.subAdministrativeArea)
                    self.County.text = Countymap! + ", " + Statemap!
                }
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
        vc.COUNTY = self.County.text ?? "not found"
        vc.STATE = self.Statemap
        vc.numPositive = self.numPositive
        vc.numUsers = self.numUsers
    }
}

