//
//  EventObject.swift
//  VenU App
//
//  Created by X Code User on 11/30/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import Foundation

struct EventObject {
    var key:String?
    var eventName:String?
    var eventDate:Date?
    var eventTime:Date?
    var eventType:String?
    var eventDesc:String?
    var eventLoc:String?
    var eventLat:Double?
    var eventLon:Double?
    var eventPub:Bool?
    var placeId:String?
    
    init(key:String?, eventName:String?, eventDate:Date?, eventTime:Date?, eventType:String?, eventLoc:String?, eventDesc:String?, eventLat:Double?, eventLon:Double?, eventPub:Bool?, placeId:String?) {
        self.key = key
        self.eventName = eventName
        self.eventDate = eventDate
        self.eventTime = eventTime
        self.eventType = eventType
        self.eventLoc = eventLoc
        self.eventDesc = eventDesc
        self.eventLat = eventLat
        self.eventLon = eventLon
        self.eventPub = eventPub
        self.placeId = placeId
    }
    
    init(eventName:String?, eventDate:Date?, eventTime:Date?, eventType:String?, eventLoc:String?, eventDesc:String?, eventLat:Double?, eventLon:Double?, eventPub:Bool?, placeId:String?) {
        self.init(key: nil, eventName: eventName, eventDate: eventDate, eventTime: eventTime, eventType: eventType, eventLoc: eventLoc, eventDesc: eventDesc, eventLat: eventLat, eventLon: eventLon, eventPub: eventPub, placeId: placeId)
    }
    
    init() {
        self.init(key: nil, eventName: nil, eventDate: nil, eventTime: nil, eventType: nil, eventLoc: nil, eventDesc: nil, eventLat: nil, eventLon: nil, eventPub: nil, placeId: nil)
    }
}
