//
//  EventDetailsViewController.swift
//  VenU App
//
//  Created by X Code User on 12/5/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Social


class EventDetailsViewController: UIViewController {

    @IBOutlet weak var googleImageView: UIImageView!
    @IBOutlet weak var EventName: UILabel!
    @IBOutlet weak var EventDandT: UILabel!
    @IBOutlet weak var EventLocation: UILabel!
    @IBOutlet weak var EventType: UILabel!
    @IBOutlet weak var EventDesc: UITextView!
    
    var Event : EventObject?
    
    // Cancel Button
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // Share Button
    @IBAction func showShareOptions(_ sender: UIBarButtonItem) {
        let actionSheet = UIAlertController(title: "", message: "Share event", preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let tweetAction = UIAlertAction(title: "Share on Twitter", style: UIAlertActionStyle.default) {(action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
                let twitterComposeVC = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
                twitterComposeVC?.setInitialText("Check out this event!")
                
                self.present(twitterComposeVC!, animated: true, completion: nil)
            } else {
                self.showAlertMessage(message: "You are not logged in to your Twitter account.")
            }
        }
        
        let facebookAction = UIAlertAction(title: "Share on Facebook", style: UIAlertActionStyle.default) {(action) -> Void in
            if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeFacebook) {
                let facebookComposeVC = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
                facebookComposeVC?.setInitialText("Check out this event!")
                
                self.present(facebookComposeVC!, animated: true, completion: nil)
            } else {
                self.showAlertMessage(message: "You are not logged in to your Facebook account.")
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) -> Void in
            
        }
        
        actionSheet.addAction(tweetAction)
        actionSheet.addAction(facebookAction)
        actionSheet.addAction(dismissAction)
        
        present(actionSheet, animated: true, completion: nil)
    }
    
    // Shows Alert Message
    func showAlertMessage(message: String!) {
        let alertController = UIAlertController(title: "EasyShare", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
        present(alertController, animated: true, completion: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.refreshEvent()
        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshEvent(){
        
        self.EventName.text = self.Event?.eventName
        self.EventDandT.text = self.Event?.eventDate?.short
        self.EventType.text = self.Event?.eventType
        self.EventDesc.text = self.Event?.eventDesc
        self.EventLocation.text = self.Event?.eventLoc
    }

}
