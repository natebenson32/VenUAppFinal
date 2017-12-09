//
//  EventEntry.swift
//  VenU App
//
//  Created by X Code User on 12/7/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import Foundation

enum EntryType : Int {
    case text = 1
    case photo
    case audio
    case video
}

struct EventEntry {
    var key : String?
    var type: EntryType?
    var caption : String?
    var url : String
    var thumbnailUrl : String
    var date : Date?
    var lat : Double?
    var lng : Double?
    
    init(key: String?, type: EntryType?, caption: String?, url: String, thumbnailUrl: String, date: Date?, lat: Double?, lng: Double?)
    {
        self.key = key
        self.type = type
        self.caption = caption
        
        self.date = date
        self.lat = lat
        self.lng = lng
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
}
