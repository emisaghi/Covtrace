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
import Firebase
import FirebaseAuth
import FirebaseDatabase
class mapController: UIViewController{
    var Countymap = ""
    var Statemap =  ""
    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var County: UILabel!
    @IBOutlet weak var State: UILabel!
    var numPositive = 0
    var numUsers = 0
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        getPositive()
        checkLocationServices()
        navigationBar.rightBarButtonItem = UIBarButtonItem(title:"My Dashboard",
        style:.plain,
        target:self,
        action:#selector(goToDashboard))
        self.County.text = Countymap
        self.State.text = Statemap
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
    func getPositive(){
//        var property = ""
        let db = Firestore.firestore()
        let docRef = db.collection("users").document(PPKController.myPeerID()).collection("all-contacts")
       docRef.getDocuments { (snapshot, error) in
            // [START_EXCLUDE]
            if error != nil {
                print("error", error!)
            }
            else {
                print(snapshot?.documents.count ?? 0)
                self.numUsers = snapshot?.documents.count ?? 0
                for document in snapshot!.documents {
                    print(document.documentID)
                    //let seconds = 0.001
                    //DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
                        var STATUS = ""
                        let docRefe = db.collection("users").document(document.documentID)
                            docRefe.getDocument(source: .server) { (document, error) in
                                if let document = document {
                                    STATUS = document.get("status") as? String ?? "none"
                                    print(STATUS)
                                    if (STATUS == "positive"){
                                        self.numPositive += 1
                                    }
                                } else {
                                    print("Document does not exist in cache")
                                }

                        }
                    // print(self.numPositive)
                //}
            }
            // [END_EXCLUDE]
        }
        }

//        docRef.whereField("status", isEqualTo: "positive")
//            .getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                } else {
//                    for document in querySnapshot!.documents {
//                        print("\(document.documentID) => \(document.data())")
//                    }
//                }
//        }
        // let docRef = db.collection("users").document(PPKController.myPeerID())
        
//        docRef.getDocument(source: .server) { (document, error) in
//            if let document = document {
//                property = document.get(PPKController.myPeerID()) as? String ?? "none"
//                print (PPKController.myPeerID())
//                print(property)//other users PeerID
//            } else {
//                property = "none"
//                print("Document does not exist in cache")
//            }
//        }
//        test: if property == "none"{
//            break test
//        }else{

//            }
//        }
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
                    self.County.text = Countymap
                    self.State.text = Statemap
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
        vc.COUNTY = self.County.text!
        vc.STATE = self.State.text!
        vc.numPositive = self.numPositive
        vc.numUsers = self.numUsers
    }
}

