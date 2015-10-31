//
//  ViewController.swift
//  AirportChallenge
//
//  Created by Roger TAN on 30/10/15.
//  Copyright © 2015 Roger TAN. All rights reserved.
//

import UIKit
import Firebase
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var latitudeTectField: UITextField!
    @IBOutlet weak var longitudeTextField: UITextField!
    @IBOutlet weak var airportCodeTextField: UITextField!
    @IBOutlet weak var statusLabel: UILabel!
    
    var airportsInformation: NSDictionary!
    var isLoadingAirportsList: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.isLoadingAirportsList = true
        let firebaseRef = Firebase(url:"https://publicdata-airports.firebaseio.com/")
        firebaseRef.observeEventType(.Value, withBlock: {
            snapshot in
            self.isLoadingAirportsList = false
            self.airportsInformation = snapshot.value as! NSDictionary
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func searchAction(sender: UIButton) {
        
        let latitude: Double = Double(latitudeTectField.text!)!
        let longitude: Double = Double(longitudeTextField.text!)!
        let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude);
        let region = MKCoordinateRegionMakeWithDistance(coordinate, 200, 200)

        let localSearchRequest: MKLocalSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = "Airport"
        localSearchRequest.region = region
        
        let localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (response, error) -> Void in
            if (response?.mapItems.count == 0) {
                print("Not found");
            } else {
                for item in (response?.mapItems)! {
                    let name = item.name;
                    var airportName = name?.stringByReplacingOccurrencesOfString(" Airport", withString: "")
                    airportName = airportName?.stringByReplacingOccurrencesOfString(".", withString: "")
                    self.searchAirport(airportName!)
                }
            }
        }
        
        if airportCodeTextField.text?.isEmpty == true {
            return;
        }
    }

    private func searchAirport(airportName: String) {
        for (key, value) in self.airportsInformation {
            let name  = value["name"] as? String
            if name != nil {
                if airportName == name! {
                    let airportCode = key as! String
                    let informations: NSDictionary = self.airportsInformation[airportCode] as! NSDictionary;
                    print(informations)
                    let status = informations.objectForKey("status") as? NSDictionary
                    let delayString = status?.objectForKey("avgDelay") as? String
                    var delay: Int? = Int(delayString!)
                    if delay == nil {
                        delay = 0
                    }
                    self.statusLabel.text = "Airport Name: \(name!)\nAverage delay: \(delay!) min"
                }
            }
        }
    }
}

