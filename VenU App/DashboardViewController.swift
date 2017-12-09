//
//  SecondViewController.swift
//  VenU App
//
//  Created by X Code User on 11/28/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import Foundation

class DashboardViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var userEmail : String?
    
    fileprivate var ref : DatabaseReference?
    
    @IBOutlet weak var tableView: UITableView!

    var EventStuff : EventObject?
    
    var entry : EventObject!
    var entries : [EventObject]?
    
    var tableViewData: [(sectionHeader: String, entries: [EventObject])]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = Database.database().reference()
        self.registerForFireBaseUpdates()
        
        self.EventStuff = nil
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
                self.entries = tmpItems
                self.tableView.reloadData()
                
            }
        })
        
    }

    

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let ents = self.entries {
            return ents.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let entry = self.entries?[indexPath.row]
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "FancyCell", for: indexPath) as! EventTableViewCell
        
        cell.setValues(entry: entry!)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let entry = self.entries?[indexPath.row] else {
            return
        }
        
        self.entry = entry
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // Prepares for segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createSegue" {
            if let dest = segue.destination as? AddEventViewController {
                dest.delegate = self
            }
        } else if segue.identifier == "detailsSegue" {
            if let destCtrl = segue.destination as? EventDetailsViewController {
                destCtrl.Event = self.entry
            }
        }
        
    }
}


//Add Event set function
extension DashboardViewController : EventCreateDelegate {
    func set(inputData: EventObject) {
        // save history to firebase
        let newChild = self.ref?.child("entries").childByAutoId()
        newChild?.setValue(self.toDictionary(vals: inputData))
        
    }
    
    func toDictionary(vals: EventObject) -> NSMutableDictionary {
        return [
            "name": vals.eventName! as NSString,
            "date": vals.eventDate!.short as NSString,
            "time": vals.eventTime!.short as NSString,
            "type" : vals.eventType! as NSString,
            "loc" : vals.eventLoc! as NSString,
            "desc" : vals.eventDesc! as NSString,
            "lat" : vals.eventLat! as NSNumber,
            "lon" : vals.eventLon! as NSNumber,
            "pub" : vals.eventPub! as NSNumber,
            "id" : vals.placeId! as NSString
        ]
    }
}

extension Date {
    struct Formatter {
        static let iso8601: DateFormatter = {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSxxx"
            return formatter
        }()
        
        static let short: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "MM-dd-yyyy"
            return formatter
        }()
    }
    
    var short: String {
        return Formatter.short.string(from: self)
    }
    
    var iso8601: String {
        return Formatter.iso8601.string(from: self)
    }
}

extension String {
    var dateFromISO8601: Date? {
        return Date.Formatter.iso8601.date(from: self)
    }
}

