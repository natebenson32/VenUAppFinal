//
//  AccountViewController.swift
//  VenU App
//
//  Created by X Code User on 11/30/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Eureka
import CoreLocation

class AccountViewController: FormViewController, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var allEnts : [EventObject]?
    var searchEnts: [EventObject]?
    var locArr: [CLLocation]?
    var curLat: Double?
    var curLon: Double?
    var radius: Double?
    
    fileprivate var ref : DatabaseReference?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        radius = 50.0
        
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
        
        curLat = 42.9639
        curLon = 85.8889
        
        
        form +++ Section()
            <<< LabelRow(){ row in
                row.title = "E-mail Address:"
                row.value = "Username"
                row.tag = "emailtag"
            }
            <<< SliderRow(){ row in
                row.title = "Event Search Radius (miles):"
                row.minimumValue = 1
                row.maximumValue = 100
                row.value = 50
                row.steps = 100
                row.displayValueFor = {
                    return "\(Int($0 ?? 0))"
                }
                row.tag = "radtag"
                radius = Double(row.value!)
            }
            <<< ButtonRow(){ row in
                row.title = "Save"
                row.onCellSelection(saveRadius(cell:row:))
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = UIColor.red
            }
            <<< ButtonRow(){ row in
                row.title = "Logout"
                row.onCellSelection(buttonTapped(cell:row:))
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = UIColor.blue
            }
        self.registerForFireBaseUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            print(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == CLAuthorizationStatus.denied) {
            showLocationDisabledPopUp()
        }
    }
    
    func showLocationDisabledPopUp() {
        let alertController = UIAlertController(title: "Background Location Access Disabled",
                                                message: "In order to deliver pizza we need your location",
                                                preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        let openAction = UIAlertAction(title: "Open Settings", style: .default) { (action) in
            if let url = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    fileprivate func registerForFireBaseUpdates()
    {
        self.ref!.child("entries").observe(.value, with: { snapshot in
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [EventObject]()
                for (_,val) in postDict.enumerated() {
                    let entry = val.1 as! Dictionary<String,AnyObject>
                    let name : String? = entry["name"] as! String?
                    let date : String? = entry["date"] as! String?
                    let time : String? = entry["time"] as! String?
                    let type : String? = entry["type"] as! String?
                    let loc : String? = entry["loc"] as! String?
                    let desc : String? = entry["desc"] as! String?
                    let lat : Double? = entry["lat"] as! Double?
                    let lon : Double? = entry["lon"] as! Double?
                    let pub : Bool? = entry["pub"] as! Bool?
                    let id : String? = entry["id"] as! String?
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MM-dd-yyyy"
                    let dateObj = dateFormatter.date(from: date!)
                    
                    let timeFormatter = DateFormatter()
                    timeFormatter.dateFormat = "HH:mm"
                    let timeObj = dateFormatter.date(from: time!)
                    
                    tmpItems.append(EventObject(eventName: name, eventDate: dateObj, eventTime: timeObj, eventType: type, eventLoc: loc, eventDesc: desc, eventLat: lat, eventLon: lon, eventPub: pub, placeId: id))
                    
                }
                self.allEnts = tmpItems
                print("Got there")
            }
        })
        
    }
    
    func calcDistance(curLat: Double?, curLon: Double?, newLat: Double?, newLon: Double?) -> Double {
        let p1 = CLLocation(latitude: curLat!, longitude: curLon!)
        let p2 = CLLocation(latitude: newLat!, longitude: newLon!)
        let distance = p1.distance(from: p2)
        return distance
    }
    
    func saveRadius(cell: ButtonCellOf<String>, row: ButtonRow){
        
        for i in 0 ..< (self.allEnts?.count)! {
            let dist = calcDistance(curLat: curLat, curLon: curLon, newLat: self.allEnts?[i].eventLat, newLon: self.allEnts?[i].eventLon)
            let miles = ((dist * 0.0621371).rounded() / 100.0)
            
            if radius! >= miles {
                self.searchEnts?.append((self.allEnts?[i])!)
            }
        }
    }
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow){
        do {
            try Auth.auth().signOut()
            print("Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let introNC = storyboard.instantiateViewController(withIdentifier: "introNC") as! UINavigationController
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = introNC
        appDelegate.window?.makeKeyAndVisible()
        
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!)
    {
        locationManager.stopUpdatingLocation()
        if ((error) != nil)
        {
            print(error)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!)
    {
        var locationArray = locations as NSArray
        var locationObj = locationArray.lastObject as! CLLocation
        var coord = locationObj.coordinate
        print(coord.latitude)
        print(coord.longitude)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
