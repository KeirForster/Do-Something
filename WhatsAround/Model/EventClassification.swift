//
//  EventClassification.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/26/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import Foundation

class EventClassification {
    
    // constants
    let name: String
    let genre: String
    let subGenre: String
    let type: String?
    let subType: String?
    
    init (name: String, genre: String, subGenre: String, type: String? = nil, subType: String? = nil) {
        self.name = name
        self.genre = genre
        self.subGenre = subGenre
        self.type = type
        self.subType = subType
    }
}
