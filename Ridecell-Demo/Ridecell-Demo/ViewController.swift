//
//  ViewController.swift
//  Ridecell-Demo
//
//  Created by Jangey Lu on 6/18/19.
//  Copyright © 2019 Jangey Lu. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // show user current location
        self.mapView.showsUserLocation = true
        getSF_Location()
    }
    
    func getSF_Location()  {
        // Zoom to San Francisco by default
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.7749, -122.4194)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: newLocation, span: span)
        mapView.setRegion(region, animated: true)
    }


}

