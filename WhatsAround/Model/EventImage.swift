//
//  EventImage.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/27/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import Foundation
import UIKit

class EventImage {
    
    // constants
    let ratio: String
    let url: String
    let width: Int
    let height: Int
    let fallback: Bool
    
    // variables
    var eventImage: UIImage?
    
    init (
        ratio: String,
        url: String,
        width: Int,
        height: Int,
        fallback: Bool
    ) {
        self.ratio = ratio
        self.url = url
        self.width = width
        self.height = height
        self.fallback = fallback
    }
}
