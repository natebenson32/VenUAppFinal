//
//  EventObjectModel.swift
//  VenU App
//
//  Created by X Code User on 11/30/17.
//  Copyright © 2017 Nate Benson. All rights reserved.
//

import Foundation

class EventObjectModel {
    fileprivate var items : [EventObject] = [EventObject]()
    
    init() {
        createEventObjects()
    }
    
    func getEventObjects() -> [EventObject] {
        return self.items
    }
    
    fileprivate func createEventObjects() {
        items.append(EventObject(key: "A", eventName: "Camping Trip!", eventDate: Date.distantFuture, eventTime: Date.distantFuture, eventType: "Outdoors", eventLoc: "California", eventDesc: "A fun camping trip where we embrace the cold and drink a lot of hot chocolate!", eventLat: 40.377, eventLon: -105.522, eventPub: true, placeId: ""))
        items.append(EventObject(key: "B", eventName: "Family Get-Together", eventDate: Date.distantFuture, eventTime: Date.distantPast, eventType: "Indoors", eventLoc: "California", eventDesc: "Family and fun!", eventLat: 42.567, eventLon: -100.745, eventPub: true, placeId: ""))
    }
}
