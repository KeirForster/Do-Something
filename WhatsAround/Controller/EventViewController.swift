//
//  EventViewController.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/25/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EventViewController: UIViewController {
    
    // constants
    let EVENT_INFO_BTN: Int = 1
    let VENUE_INFO_BTN: Int = 2
    let SEATMAP_INFO_BTN: Int = 3
    let WEBVIEW_SEGUE_ID: String = "WebviewSegue"
    
    // variables
    var buttonClicked: Int?
    
    // variables
    var event: Event?
    
    // outlets
    @IBOutlet weak var eventName: UILabel!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventPrice: UILabel!
    @IBOutlet weak var classificationName: UILabel!
    @IBOutlet weak var genre: UILabel!
    @IBOutlet weak var subGenre: UILabel!
    @IBOutlet weak var venueName: UIButton!
    @IBOutlet weak var distance: UILabel!
    @IBOutlet weak var venueCity: UILabel!
    @IBOutlet weak var venueCountry: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.updateUI()
    }
    
    
    
    // MARK: - UI Updates
    /***************************************************************/
    
    private func updateUI() -> Void {
        guard event != nil else {
            print("event is nil")
            return
        }
        
        eventName.text = event!.name
        eventImage.getEventImage(imageUrl: event!.images[0].url)
        eventPrice.text = "$\(event!.price?.min ?? 0) - $\(event!.price?.max ?? 0)"
        classificationName.text = event!.classification.name
        genre.text = event!.classification.genre
        subGenre.text = event!.classification.subGenre
        venueName.setTitle(event!.venue.name, for: .normal)
        distance.text = "\(event!.distance) \(event!.units)"
        venueCity.text = "\(event!.venue.city), \(event!.venue.state)"
        venueCountry.text = event!.venue.country
        date.text = event!.localStartDate
    }
    
    
    
    // MARK: - Navigation
    
    @IBAction func onClick(_ sender: UIButton) {
        buttonClicked = sender.tag
        performSegue(withIdentifier: WEBVIEW_SEGUE_ID, sender: self)
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == WEBVIEW_SEGUE_ID {
            let webviewVC = segue.destination as! WebViewController
            let url = URL(string: self.getUrl())
            webviewVC.url = url
        }
    }
    
    private func getUrl() -> String {
        switch (buttonClicked!) {
            case EVENT_INFO_BTN:
                return event!.url
            case VENUE_INFO_BTN:
                return event!.venue.url
            case SEATMAP_INFO_BTN:
                return event!.seatMap
            default:
                return event!.url
        }
    }
}
