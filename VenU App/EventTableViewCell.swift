//
//  EventTableViewCell.swift
//  VenU App
//
//  Created by X Code User on 11/30/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var eName: UILabel!
    @IBOutlet weak var eTime: UILabel!
    @IBOutlet weak var eDate: UILabel!
    @IBOutlet weak var eType: UILabel!
    @IBOutlet weak var transView: UIView!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var coverImage: UIImageView!
    var entry : EventObject?
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.coverImage.backgroundColor = UIColor.cyan
        // Configure the view for the selected state
    }
    
    func setValues(entry: EventObject) {
        self.entry = entry
        self.eName.text = entry.eventName
        //self.eDate.text = entry.eventTime?.short
        self.eTime.text = "6:00PM"
        self.eDate.text = entry.eventDate?.short
        self.eType.text = entry.eventType
        
        if eType.text == "Other" {
            self.coverImage.image = UIImage(named: "map.jpg")
        } else if eType.text == "Breakfast" {
            self.coverImage.image = UIImage(named: "breakfast.jpg")
            self.typeView.backgroundColor = UIColor.yellow
            self.eType.textColor = UIColor.black
        } else if eType.text == "Lunch" {
            self.coverImage.image = UIImage(named: "lunch.jpg")
            self.typeView.backgroundColor = UIColor.green
            self.eType.textColor = UIColor.black
        } else if eType.text == "Dinner" {
            self.coverImage.image = UIImage(named: "dinner.jpg")
            self.typeView.backgroundColor = UIColor.brown
        } else if eType.text == "Camping" {
            self.coverImage.image = UIImage(named: "camping.jpg")
            self.typeView.backgroundColor = UIColor.blue
        }else if eType.text == "Late Night" {
            self.coverImage.image = UIImage(named: "latenight.jpg")
            self.typeView.backgroundColor = UIColor.black
        } else if eType.text == "Sport" {
            self.coverImage.image = UIImage(named: "sport.jpg")
            self.typeView.backgroundColor = UIColor.cyan
            self.eType.textColor = UIColor.black
        } else if eType.text == "School" {
            self.coverImage.image = UIImage(named: "college.jpg")
            self.typeView.backgroundColor = UIColor.orange
        } else if eType.text == "Concert" {
            self.coverImage.image = UIImage(named: "concert.jpg")
            self.typeView.backgroundColor = UIColor.magenta
        } else if eType.text == "Party" {
            self.coverImage.image = UIImage(named: "party.jpg")
            self.typeView.backgroundColor = UIColor.red
        }
    }

}
