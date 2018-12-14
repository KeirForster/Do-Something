//
//  EventVenue.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/26/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import Foundation

class EventVenue {
    // constants
    let name: String
    let type: String
    let id: String
    let url: String
    let locale: String
    let postalCode: String
    let timeZone: String
    let city: String
    let state: String
    let country: String
    
    init (
        name: String,
        type: String,
        id: String,
        url: String,
        locale: String,
        postalCode: String,
        timeZone: String,
        city: String,
        state: String,
        country: String
    ) {
        
        self.name = name
        self.type = type
        self.id = id
        self.url = url
        self.locale = locale
        self.postalCode = postalCode
        self.timeZone = timeZone
        self.city = city
        self.state = state
        self.country = country
    }
}
