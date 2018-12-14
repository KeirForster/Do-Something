//
//  EventTableViewController.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/25/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventTableViewController: UITableViewController {
    
    // constants
    let DEFAULT_CELL_ID: String = "defaultTableCell"
    let EVENT_CELL_NIB: String = "EventTableViewCell"
    let EVENT_CELL_ID: String = "CustomEventTableViewCell"
    let EVENT_SEGUE_ID: String = "EventSegue"
    let NUM_TABLE_SECTIONS: Int = 1
    
    // variables
    var events: [Event] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.registerTableViewCells()
    }
    
    private func registerTableViewCells() -> Void {
        let eventCell = UINib(nibName: EVENT_CELL_NIB, bundle: nil)
        self.tableView.register(eventCell, forCellReuseIdentifier: EVENT_CELL_ID)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return NUM_TABLE_SECTIONS
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }
    
    
    
    // MARK: - UI Updates
    /***************************************************************/
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let customCell = tableView.dequeueReusableCell(withIdentifier: EVENT_CELL_ID, for: indexPath) as! EventTableViewCell
        let event = events[indexPath.row]
        
        customCell.logo.getEventImage(imageUrl: event.images[0].url)
        customCell.name.text = event.name
        customCell.genre.text = event.classification.genre
        customCell.price.text = "$\(event.price?.min ?? 0) - $\(event.price?.max ?? 0)"
        customCell.date.text = "\(event.localStartDate)"
        customCell.distance.text = "\(event.distance) \(event.units)"
        customCell.city.text = "\(event.venue.city)"
        return customCell
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EVENT_SEGUE_ID {
            if let indexPath = tableView.indexPathForSelectedRow {
                let eventVC = segue.destination as! EventViewController
                eventVC.event = events[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: EVENT_SEGUE_ID, sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}



// MARK: - Networking
/***************************************************************/

extension UIImageView {
    public func getEventImage(imageUrl: String) -> Void {
        Alamofire.request(imageUrl).responseData {
            response in
            
            if let data = response.result.value {
                let image = UIImage(data: data)
                self.image = image
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
}
