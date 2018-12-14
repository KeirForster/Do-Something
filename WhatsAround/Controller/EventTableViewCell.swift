//
//  EventTableViewCell.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/25/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var logo: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var city: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logo.layer.cornerRadius = 10.0
        logo.layer.masksToBounds = true
    }
}
