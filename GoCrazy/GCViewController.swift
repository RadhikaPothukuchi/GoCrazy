//
//  ViewController.swift
//  GoCrazy
//
//  Created by Radhika Pothukuchi on 9/2/17.
//  Copyright © 2017 vv. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class GCViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var annotations:[MKPointAnnotation]? = []
    var localSearch:MKLocalSearch?
    var localSearchResults:MKLocalSearchResponse?
    var localSearchRequest:MKLocalSearchRequest?
    
    lazy var locationManager = CLLocationManager.init()
    var currentLocation:CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // locationManager.distanceFilter = 0
        locationManager.requestWhenInUseAuthorization()
        //locationManager.requestAlwaysAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
        mapView.showsUserLocation = true
        currentLocation = locationManager.location
        localSearchRequest = MKLocalSearchRequest.init()
        localSearchRequest?.naturalLanguageQuery = "kid"
        
        //localSearchRequest?.region = mapView.region
        guard let location = currentLocation else {
            return
        }
        localSearchRequest?.region = MKCoordinateRegionMakeWithDistance(location.coordinate, CLLocationDistance(Double(milesToMeters(miles: 10.0))),CLLocationDistance(Double(milesToMeters(miles: 10.0))))
        guard localSearchRequest != nil else {
            return
        }
        localSearch = MKLocalSearch(request: localSearchRequest!)
        localSearch?.start(completionHandler: { (response,error) in
            guard error == nil else {
                print("local search result failed with error \(String(describing: error))")
                return
            }
            guard (response?.mapItems.count)! > 0 else {
                print("No search results found")
                return
            }
            response?.mapItems.forEach({(mapItem) in
                let annotation = MKPointAnnotation.init()
                annotation.coordinate = mapItem.placemark.coordinate
                annotation.title = mapItem.placemark.name
                self.annotations?.append(annotation)
                // print(mapItem.placemark.addressDictionary?.keys)
                print(mapItem.name as String?)
                
            })
            guard (self.annotations?.count)! > 0 else {
                print("No mapitems to update mapview")
                return
            }
            
            self.mapView.addAnnotations(self.annotations!)
            
        })

    }
    override func viewWillDisappear(_ animated: Bool) {
        NSLog("view will disappear called")
        super.viewWillDisappear(animated)
    }
    private func milesToMeters(miles: float_t) -> float_t {
        return (1609.344 * miles)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

