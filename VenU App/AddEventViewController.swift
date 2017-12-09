//
//  FirstViewController.swift
//  VenU App
//
//  Created by X Code User on 11/28/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit
import Eureka
import GooglePlacePicker

class AddEventViewController: FormViewController {
    
    var entry : EventObject?
    var location : GMSPlace?
    var delegate : EventCreateDelegate?
    
    override func viewDidLoad() {        
        super.viewDidLoad()
        
        form +++ Section("")
            <<< TextRow(){ row in
                row.title = "Event Name"
                row.placeholder = "Enter name"
                row.tag = "nametag"
                row.value = self.entry?.eventName
                row.add(rule: RuleRequired())
            }
            <<< DateRow(){ row in
                row.title = "Date"
                if let date = entry?.eventDate {
                    row.value = date
                } else {
                    row.value = Date(timeIntervalSinceNow: 0)
                }
                row.tag = "datetag"
                row.add(rule: RuleRequired())
                
            }
            <<< TimeInlineRow("Time"){ row in
                row.title = "Time"
                if let time = entry?.eventTime {
                    row.value = time
                } else {
                    row.value = Date().addingTimeInterval(60*60*24)
                }
                row.tag = "timetag"
                row.add(rule: RuleRequired())
            }
            +++ Section("VenU")
            <<< LabelRow () { row in
                row.title = "Location"
                if let loc = entry?.eventLoc {
                    row.value = loc
                } else {
                    row.value = "Tap to search"
                }
                row.tag = "LocTag"
                var rules = RuleSet<String>()
                rules.add(rule: RuleClosure(closure: { (loc) -> ValidationError? in
                    if loc == "Tap to search" {
                        return ValidationError(msg: "You must select a location")
                    } else {
                        return nil
                    }
                }))
                row.add(ruleSet:rules)
                }.onCellSelection { cell, row in
                    // crank up Google's place picker when row is selected.
                    let autocompleteController = GMSAutocompleteViewController()
                    autocompleteController.delegate = self
                    self.present(autocompleteController, animated: true,
                                 completion: nil)
            }
            <<< ActionSheetRow<String>() { row in
                row.title = "Event Type"
                row.selectorTitle = "Choose:"
                row.options = ["Other","Breakfast", "Lunch", "Dinner", "Camping", "Late Night", "Sport", "School", "Concert", "Party"]
                if let type = entry?.eventType {
                    row.value = type
                } else {
                    row.value = "None"    // initially selected
                }
                row.tag = "typetag"
            }
            <<< SwitchRow(){ row in
                row.title = "Public Event"
                if let pubevent = entry?.eventPub {
                    row.value = pubevent
                } else {
                    row.value = true
                }
                row.tag = "pubtag"
            }
            +++ Section("Description")
            <<< TextAreaRow(){ row in
                row.placeholder = "Enter details..."
                row.tag = "desctag"
                row.value = self.entry?.eventDesc
            }
            <<< ButtonRow(){ row in
                row.title = "Create"
                row.onCellSelection(self.buttonTapped)
                }.cellUpdate{cell, row in
                    cell.textLabel?.textColor = UIColor.white
                    cell.backgroundColor = UIColor.blue
            }
    }
    
    
    
    func buttonTapped(cell: ButtonCellOf<String>, row: ButtonRow){
        let errors = self.form.validate()
        if errors.count > 0 {
            print("fix your errors!")
        } else {
            let nameRow : TextRow! = form.rowBy(tag: "nametag")
            let name = nameRow.value!
            
            // Date info
            let dateRow : DateRow! = form.rowBy(tag: "datetag")
            let date = dateRow.value! as Date
            
            // Time info
            let timeRow : TimeInlineRow! = form.rowBy(tag: "timetag")
            let time = timeRow.value!
            
            // Location info
            let locRow : LabelRow! = form.rowBy(tag: "LocTag")
            let loc = locRow.value!
            let lat = (self.location?.coordinate.latitude)!
            let lon = (self.location?.coordinate.longitude)!
            let id = (self.location?.placeID)!
            
            // Type info
            let typeRow: ActionSheetRow<String>! = form.rowBy(tag: "typetag")
            let type = typeRow.value!
            
            // Public info
            let pubRow : SwitchRow! = form.rowBy(tag: "pubtag")
            let pub = pubRow.value!
            
            // Description info
            let descRow : TextAreaRow! = form.rowBy(tag: "desctag")
            let desc = descRow.value!
            
            if let del = self.delegate {
                del.set(inputData: EventObject(eventName: name, eventDate: date, eventTime: time, eventType: type, eventLoc: loc, eventDesc: desc, eventLat: lat, eventLon: lon, eventPub: pub, placeId: id))
            }
            self.dismiss(animated: true, completion: nil)
            print("We got here boii")
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
}

protocol EventCreateDelegate {
    func set(inputData: EventObject)
}

extension AddEventViewController: GMSAutocompleteViewControllerDelegate {
    
    public func viewController(_ viewController: GMSAutocompleteViewController,
                               didFailAutocompleteWithError error: Error)
    {
        print(error.localizedDescription)
    }
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController,
                        didAutocompleteWith place: GMSPlace)
    {

        let row : LabelRow? = form.rowBy(tag: "LocTag")
        row?.value = place.name
        row?.validate()
        
        let indexPath = IndexPath(row: 1, section: 0)
        self.tableView?.reloadRows(at: [indexPath], with: .none)
        self.location = place
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    func viewController(viewController: GMSAutocompleteViewController,
                        didFailAutocompleteWithError error: NSError)
    {
        // TODO: handle the error.
        print("Error: ", error.description)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController)
    {
        self.dismiss(animated: true, completion: nil)
        let row: LabelRow? = form.rowBy(tag: "LocTag")
        row?.validate()
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController:
        GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController:
        GMSAutocompleteViewController)
    {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}

