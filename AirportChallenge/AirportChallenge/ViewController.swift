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
    
    var airportsInformation: NSArray!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

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
                print(response)
            }
        }
        
        if airportCodeTextField.text?.isEmpty == true {
            return;
        }
        

    }

    private func searchAirport(airportName: String) {
        let firebaseRef = Firebase(url:"https://publicdata-airports.firebaseio.com/")
        firebaseRef.observeEventType(.Value, withBlock: {
            snapshot in
//            self.airportsInformation = snapshot.value as! NSDictionary
            let airports = snapshot.value as! NSDictionary
            for (key, value) in airports {
                //                let item = airport as NSDictionary
                let name  = value["name"]
                if name != nil {
                    print(name)
                }
            }
//            if snapshot.hasChild(self.airportCodeTextField.text)  {
//                let informations: NSDictionary = snapshot.value[self.airportCodeTextField.text!] as! NSDictionary;
//                print(informations)
//                let status = informations.objectForKey("status") as? NSDictionary
//                let delayString = status?.objectForKey("avgDelay") as? String
//                var delay: Int? = Int(delayString!)
//                if delay == nil {
//                    delay = 0
//                }
//                self.statusLabel.text = "Average delay: \(delay!) min"
//            }
            //            if (snapshot.value.objectForKey("ATL")) {
            //                print(snapshot.value["ATL"])
            //            }
        })
        

    }
}

