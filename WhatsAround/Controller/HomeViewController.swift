//
//  ViewController.swift
//  WhatsAround
//
//  Created by Keir Forster on 11/25/18.
//  Copyright © 2018 Keir Forster. All rights reserved.
//

import UIKit
import CoreLocation
import SVProgressHUD
import Alamofire
import SwiftyJSON

class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    // constants
    let EVENTS_URL: String = "https://app.ticketmaster.com/discovery/v2/events.json"
    let API_KEY: String = "SFLNCHw9Gfdon8SQikm1GVjiS0tOgKl3"
    let SEARCHING_MSG: String = "Searching..."
    let EVENT_TABLE_SEGUE_ID: String = "EventTableSegue"
    let RADIUS_UNIT_KM: String = "km"
    let RADIUS_UNIT_MI_ABBREV: String = "mi"
    let RADIUS_UNIT_MILES: String = "miles"
    let DEFAULT_RADIUS: Int = 15
    let MAX_RES_COUNT: Int = 100
    let locationManager: CLLocationManager = CLLocationManager()
    
    // variables
    var geoPoint: String?
    var radiusUnit: String?
    var radius: Int?
    var locationAcquired: Bool = false
    var events: [Event] = []
    var searchingEvents: Bool = false
    
    // outlets
    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var unitsView: UIView!
    
    // actions
    @IBAction func onMetricChange(_ sender: UISwitch) {
        radiusUnit = sender.isOn ? RADIUS_UNIT_KM : RADIUS_UNIT_MILES
        
        if radius == nil {
            radius = DEFAULT_RADIUS
        }
        
        if radiusUnit == RADIUS_UNIT_MILES {
            radiusLabel.text = "\(radius!) \(RADIUS_UNIT_MI_ABBREV)"
        } else {
            radiusLabel.text = "\(radius!) \(radiusUnit!)"
        }
    }
    
    @IBAction func onRadiusChange(_ sender: UISlider) {
        radius = Int(sender.value)
        
        if radiusUnit == nil {
            radiusUnit = RADIUS_UNIT_KM
        }
        
        if radiusUnit == RADIUS_UNIT_MILES {
            radiusLabel.text = "\(Int(sender.value)) \(RADIUS_UNIT_MI_ABBREV)"
        } else {
            radiusLabel.text = "\(Int(sender.value)) \(radiusUnit!)"
        }
    }
    
    @IBAction func searchEvents(_ sender: UIButton) {
        SVProgressHUD.show(withStatus: SEARCHING_MSG)
        if !searchingEvents {
            searchingEvents = true
            self.getLocation()
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUIDefaults()
    }
    
    
    
    // MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    private func getLocation() -> Void {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    private func getParameters() -> [String:String] {
        if radius == nil {
            radius = DEFAULT_RADIUS
        }
        
        if radiusUnit == nil {
            radiusUnit = RADIUS_UNIT_KM
        }
        
        return [
            "apikey": API_KEY,
            "radius": "\(radius!)",
            "geoPoint": "\(geoPoint!)",
            "unit": radiusUnit!,
            "size": "\(MAX_RES_COUNT)"
        ]
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            locationManager.stopUpdatingLocation()
            locationManager.delegate = nil
            
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            geoPoint = "\(latitude),\(longitude)"
            locationAcquired = true
            self.getEvents(url: EVENTS_URL, parameters: self.getParameters())
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        locationAcquired = false
    }
    
    
    
    // MARK: - Networking
    /***************************************************************/
    
    private func getEvents(url: String, parameters: [String : String]) -> Void {
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            response in
            
            if response.result.isSuccess {
                self.parseJsonResults(json: JSON(response.result.value!))
            } else {
                print("Error \(String(describing: response.result.error))")
            }
        }
    }
    
    
    
    // MARK: - JSON Parsing
    /***************************************************************/
    
    private func parseJsonResults(json: JSON) -> Void {
        let eventsFound = json["_embedded"]["events"].arrayValue
        events = []
        
        if eventsFound.count > 0 {
            for event in eventsFound {
                events.append(self.parseEvent(event))
            }
            self.goToEventsTable()
        } else {
            self.alertNoEvents()
        }
        
        self.updateUI()
        self.searchingEvents = false
    }
    
    private func parseEvent(_ event: JSON) -> Event {
        let images = self.parseEventImages(event["images"].arrayValue)
        let classification = self.parseEventClassification(event["classifications"].arrayValue)
        let venue = self.parseEventVenue(event["_embedded"]["venues"].arrayValue)
        let price = self.parseEventPrice(event["priceRanges"].arrayValue)
        
        return Event(
            name: event["name"].stringValue,
            type: event["type"].stringValue,
            id: event["id"].stringValue,
            url: event["url"].stringValue,
            locale: event["locale"].stringValue,
            images: images,
            distance: event["distance"].doubleValue,
            units: event["units"].stringValue,
            localStartDate: event["dates"]["start"]["localDate"].stringValue,
            classification: classification,
            venue: venue,
            price: price,
            seatMap: event["seatmap"]["staticUrl"].stringValue
        )
    }
    
    private func parseEventImages(_ images: [JSON]) -> [EventImage] {
        var tempImages: [EventImage] = []
        
        for image in images {
            tempImages.append(
                EventImage(
                    ratio: image["ratio"].stringValue,
                    url: image["url"].stringValue,
                    width: image["width"].intValue,
                    height: image["height"].intValue,
                    fallback: image["fallback"].boolValue
                )
            )
        }
        return tempImages
    }
    
    private func parseEventClassification(_ classifications: [JSON]) -> EventClassification {
        let type = classifications[0]["type"]["name"].stringValue
        let subType = classifications[0]["subType"]["name"].stringValue
        
        return EventClassification(
            name: classifications[0]["segment"]["name"].stringValue,
            genre: classifications[0]["genre"]["name"].stringValue,
            subGenre: classifications[0]["subGenre"]["name"].stringValue,
            type: type == "Undefined" ? nil : type,
            subType: subType == "Undefined" ? nil : subType
        )
    }
    
    private func parseEventVenue(_ venues: [JSON]) -> EventVenue {
        return EventVenue(
            name: venues[0]["name"].stringValue,
            type: venues[0]["type"].stringValue,
            id: venues[0]["id"].stringValue,
            url: venues[0]["url"].stringValue,
            locale: venues[0]["locale"].stringValue,
            postalCode: venues[0]["postalCode"].stringValue,
            timeZone: venues[0]["timeZone"].stringValue,
            city: venues[0]["city"]["name"].stringValue,
            state: venues[0]["state"]["name"].stringValue,
            country: venues[0]["country"]["name"].stringValue
        )
    }
    
    private func parseEventPrice(_ priceRanges: [JSON]) -> EventPrice? {
        guard priceRanges.count > 0 else {
            return nil
        }
        
        return EventPrice(
            type: priceRanges[0]["type"].stringValue,
            currency: priceRanges[0]["currency"].stringValue,
            min: priceRanges[0]["min"].doubleValue,
            max: priceRanges[0]["max"].doubleValue
        )
    }
    
    
    
    // MARK: - UI Updates
    /***************************************************************/
    
    private func updateUI() -> Void {
        SVProgressHUD.dismiss()
    }
    
    private func setUIDefaults() -> Void {
        unitsView.layer.cornerRadius = 5.0
    }
    
    private func alertNoEvents() -> Void {
        let alert = UIAlertController(title: "No Events Found", message: "Try increasing your search radius to broaden your search area", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    
    
    // MARK: - Navigation
    /***************************************************************/
    
    private func goToEventsTable() -> Void {
        self.performSegue(withIdentifier: EVENT_TABLE_SEGUE_ID, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == EVENT_TABLE_SEGUE_ID {
            let destinationVC = segue.destination as! EventTableViewController
            destinationVC.events = events
        }
    }
}

