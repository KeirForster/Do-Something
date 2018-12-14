//
//  EventPrice.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/26/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import Foundation

class EventPrice {
    
    // constants
    let type: String
    let currency: String
    let min: Double
    let max: Double
    
    init (type: String, currency: String, min: Double, max: Double) {
        self.type = type
        self.currency = currency
        self.min = min
        self.max = max
    }
}
