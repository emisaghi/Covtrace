//
//  AppDelegate.swift
//  Covtrace
//
//  Created by Ethan on 2020-04-12.
//  Copyright © 2020 Covtracers. All rights reserved.
//

import UIKit
import Firebase
import MapKit
import CoreLocation
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, PPKControllerDelegate {

    var window: UIWindow?
    var numPositive = 0
    var numContacts = 0
    var peerList : Array<String> = Array()


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
     // Override point for customization after application launch
     FirebaseApp.configure()
        /*let storyboard = UIStoryboard(name: "Main", bundle: .main)
        if let initialViewController = storyboard.instantiateInitialViewController() {
            window?.rootViewController = initialViewController
            window?.makeKeyAndVisible()
        }*/
    PPKController.enable(withConfiguration: "4b45a4a433314a4eb20a3742b7168325", observer: self)
    PPKController.enableProximityRanging()
    return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
         // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
         return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
     // Called when the user discards a scene session.
     // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
     // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    func ppkControllerInitialized() {
    PPKController.startDiscovery(withDiscoveryInfo: "Hello".data(using: .utf8), stateRestoration: true)
    }
    
    func proximityStrengthChanged(for peer: PPKPeer) {
    if (peer.proximityStrength.rawValue > PPKProximityStrength.weak.rawValue) {
        print("\(peer.peerID) is in range, do something with it")
    }
    else {
    print("\(peer.peerID) is not yet in range")
        }
    }
    
    func peerDiscovered(_ peer: PPKPeer) {
        if let discoveryInfo = peer.discoveryInfo {
        let discoveryInfoString = String(data: discoveryInfo, encoding: .utf8)
       
        let db = Firestore.firestore()
        let formatter = DateFormatter()
          formatter.dateStyle = .short
        formatter.timeStyle = .short
        let datetime = formatter.string(from: Date())
        db.collection("users").document(PPKController.myPeerID()).setData(["peerID": peer.peerID, "date_time": datetime], merge: true)
       
        print("\(peer.peerID) is here with discovery info: \(String(describing: discoveryInfoString))")
        peerList.append(peer.peerID)
        for p in peerList {
            if !(p.isEqual(peer.peerID)) {
                self.numContacts += 1
            }
        }
      }
    }

    func peerLost(_ peer: PPKPeer)  {
    print("\(peer.peerID) is no longer here")
    }
}
