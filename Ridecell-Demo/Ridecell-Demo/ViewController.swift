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
    @IBOutlet weak var annotationDetails: UIView!
    @IBOutlet weak var annotationDetailsBottomEdge: NSLayoutConstraint!
    
    
    let locationManager = CLLocationManager()
    var cars:[Car] = []
    var annotations = [MKPointAnnotation()]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        
        // show user current location
        self.mapView.showsUserLocation = true
        getJson()
        getCurrentLocation()
        getSF_Location()
        addSpotOnMap()
        
        
    }
    
    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func getSF_Location()  {
        // Zoom to San Francisco by default
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(37.7749, -122.4194)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: newLocation, span: span)
        mapView.setRegion(region, animated: true)
    }

    func getJson() {
        let url = Bundle.main.url(forResource: "vehicles_data_(1)", withExtension: "json")
        
        let jsonData = url!
        let data = try! Data(contentsOf: jsonData)
        let jsonDecode = try! JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
        // print(json[0]["is_active"] as! Bool)
        
        cars = Car.cars(json: jsonDecode)
    }
    
    
    
    
    // https://api.opencagedata.com/geocode/v1/json?q=47.61328+-122.342385&key=1598abf0be694459b9e15c4f7ca662bd
    func addSpotOnMap() {
        let annotationRegion = MKPointAnnotation()
        
        // adding each spot into mapView
        for car in cars {
            let lat = car.lat
            let lng = car.lng
            let address = "Address not available"
            getAddressfromLatLog(lat, lng)
            
            // If lat & lng in JSON, put it into Map
            if(lat.isZero && lng.isZero){
                print("Car dont have lat,lnt.")
            } else {
                let carPlate = car.license_plate_number
                let spotCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
                
                // adding each spot into MAP
                let annotation = MKPointAnnotation()
                annotation.coordinate = spotCoordinate
                annotation.title = carPlate
                annotation.subtitle = address
                annotations.append(annotation)
                
                // update last annotation coordinate
                annotationRegion.coordinate = spotCoordinate
            }
        }
        mapView.addAnnotations(annotations)
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation else {
            return
        }
        annotationDetailsBottomEdge.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        // When user select, move annotation to the center
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            mapView.setCenter(annotation.coordinate, animated: true)
        }
    }

    @IBAction func tapMap(_ sender: Any) {
        annotationDetailsBottomEdge.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    
    
    
    
    
    
    func getAddressfromLatLog(_:Double, _:Double) {
        //let urlString = "https://api.opencagedata.com/geocode/v1/json?q=\(lat)+\(lng)&key=1598abf0be694459b9e15c4f7ca662bd"
        let urlString = "https://api.myjson.com/bins/h53tt"
        let urlRequest = URL(string: urlString)!
        let session = URLSession.shared
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            // this is where the completion handler code goes
            if error != nil {
                print(error!.localizedDescription)
            }
            
            guard let data = data else { return }
            let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            let results = dataDictionary["results"] as! [[String: Any]]
            let formatted = results[0]["formatted"] as? String ?? "Address not available"
            print(formatted)
            
        })
        task.resume()
        
    }

}

