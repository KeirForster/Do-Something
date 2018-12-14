//
//  Event.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/26/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import Foundation

class Event {
    
    // constants
    let name: String
    let type: String
    let id: String
    let url: String
    let locale: String
    let images: [EventImage]
    let distance: Double
    let units: String
    let localStartDate: String
    let classification: EventClassification
    let venue: EventVenue
    let price: EventPrice?
    let seatMap: String
    
    init(
        name: String,
        type: String,
        id: String,
        url: String,
        locale: String,
        images: [EventImage],
        distance: Double,
        units: String,
        localStartDate: String,
        classification: EventClassification,
        venue: EventVenue,
        price: EventPrice? = nil,
        seatMap: String) {
        
        self.name = name
        self.type = type
        self.id = id
        self.url = url
        self.locale = locale
        self.images = images
        self.distance = distance
        self.units = Event.abbreviateUnits(units)
        self.localStartDate = localStartDate
        self.classification = classification
        self.venue = venue
        self.price = price
        self.seatMap = seatMap
    }
    
    private static func abbreviateUnits(_ units: String) -> String {
        switch (units) {
            case "KILOMETERS":
                return "km"
            case "MILES":
                return "mi"
            default:
                return "km"
        }
    }
}
