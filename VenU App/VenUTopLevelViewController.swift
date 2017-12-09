//
//  VenUTopLevelViewController.swift
//  VenU App
//
//  Created by X Code User on 12/7/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class VenUTopLevelViewController: UIViewController {

    var shouldLoad = true
    var userEmail : String?
    var entries : [EventObject]? {
        didSet {
            self.journalsDidLoad()
        }
    }
    
    var ref : DatabaseReference?
    var userId : String? = "" {
        didSet {
            if userId != nil && userId != "" {
                // pop off any controllers beyond this one.
                if var count = self.navigationController?.childViewControllers.count
                {
                    if count > 1 {
                        count -= 1
                        for _ in 1...count {
                            _ = self.navigationController?.popViewController(animated: true)
                        }
                    }
                }
                self.ref = Database.database().reference()
                if self.shouldLoad {
                    self.registerForFireBaseUpdates()
                }
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let tbc = self.tabBarController as? VenUTabBarViewController {
            self.userId = tbc.userId
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // unregister from listeners here.
        if let r = self.ref {
            r.removeAllObservers()
        }
        
    }
    
    fileprivate func registerForFireBaseUpdates()
    {
        
        self.ref!.child(self.userId!).observe(.value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            
            if let postDict = snapshot.value as? [String : AnyObject] {
                var tmpItems = [EventObject]()
                for (_,val) in postDict.enumerated() {
                    //print("key = \(key) and val = \(val)")
                    let entry = val.1 as! Dictionary<String,AnyObject>
                    print ("entry=\(entry)")
                    let key = val.0
                    let name : String? = entry["name"] as! String?
                    let date : Date? = entry["date"] as! Date?
                    let time : Date? = entry["time"] as! Date?
                    let type : String? = entry["type"] as! String?
                    let loc : String? = entry["loc"] as! String?
                    let desc : String? = entry["desc"] as! String?
                    let lat : Double? = entry["lat"] as! Double?
                    let lon : Double? = entry["lon"] as! Double?
                    let pub : Bool? = entry["pub"] as! Bool?
                    let id : String? = entry["id"] as! String?

                    
                    tmpItems.append(EventObject(key: key, eventName: name, eventDate: date, eventTime: time, eventType: type, eventLoc: loc, eventDesc: desc, eventLat: lat, eventLon: lon, eventPub: pub, placeId: id))
                    
                }
                strongSelf.entries = tmpItems
                //strongSelf.journalsDidLoad()
                //strongSelf.sortIntoSections(journals: strongSelf.journals!)
            }
        })
        
    }
    
    
    @IBAction func logout() {
        // Note we need not explicitly do a segue as the auth listener on our
        // top level tab bar controller will detect and put up the login.
        do {
            try Auth.auth().signOut()
            print("Logged out")
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        self.entries?.removeAll()
        self.entries = nil
        //        self.tableViewData?.removeAll()
        self.userEmail = nil
    }
    
    // Hook that gets called after journals are loaded.
    func journalsDidLoad()
    {
        
    }

}
