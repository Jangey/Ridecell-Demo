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
    
    class CustomPointAnnotation: MKPointAnnotation {
        var tag: Int!
        var lat: String!
        var lng: String!
    }
    
    let locationManager = CLLocationManager()
    var cars:[Car] = []
    var annotations = [CustomPointAnnotation()]
    
    @IBOutlet weak var vehicleName: UILabel!
    @IBOutlet weak var vehicleReminingRange: UILabel!
    @IBOutlet weak var vehicleLicensePlate: UILabel!
    @IBOutlet weak var vehicleImage: UIImageView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        mapView.delegate = self
        annotationDetailsBottomEdge.constant = -250
        
        // show user current location
        self.mapView.showsUserLocation = true
        getJson()
        getCurrentLocation()
        getSF_Location()
        addSpotOnMap()
        getAddressfromLatLog(annotations)
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
        
        // adding each spot into mapView
        for (index, car) in cars.enumerated() {
            let lat = car.lat
            let lng = car.lng
            let address = "Address not available"
            
            // If lat & lng in JSON, put it into Map
            if(lat.isZero && lng.isZero){
                print("Car dont have lat,lnt.")
            } else {
                let carPlate = car.license_plate_number
                let spotCoordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, lng)
                
                // adding each spot into MAP
                let annotation = CustomPointAnnotation()
                annotation.coordinate = spotCoordinate
                annotation.title = carPlate
                annotation.subtitle = address
                annotation.tag = index
                annotation.lat = String(lat)
                annotation.lng = String(lng)
                annotations.append(annotation)
            }
        }
        mapView.addAnnotations(annotations)
    }
    

    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? CustomPointAnnotation else {
            return
        }
        annotationDetailsBottomEdge.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        
        // Display current vehicle details
        vehicleName.text = "VehicleName: " + cars[annotation.tag].vehicle_make
        vehicleReminingRange.text = "Remaining Range: " + String(cars[annotation.tag].remaining_mileage)
        vehicleLicensePlate.text = "License Plate: " + cars[annotation.tag].license_plate_number
        
        
        
        let dataImage = try? Data(contentsOf:  URL(string: cars[annotation.tag].vehicle_pic_absolute_url)!)
        
        if let imageData = dataImage {
            vehicleImage.image = UIImage(data: imageData)
            
        }
        
        // When user select, move annotation to the center
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            // mapView.setCenter(annotation.coordinate, animated: true)
            
            let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region:MKCoordinateRegion = MKCoordinateRegion(center: annotation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }
    }

    @IBAction func tapMap(_ sender: Any) {
        annotationDetailsBottomEdge.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @IBAction func hideBottom(_ sender: Any) {
        annotationDetailsBottomEdge.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    @IBAction func reservePress(_ sender: Any) {
        let alert = UIAlertController(title: "Reserve Fail", message: "Sorry, It's demo app.\n Cannot be reserve!", preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func meButtomPress(_ sender: Any) {
        // Zoom to San Francisco by default
        let span: MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let newLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake((locationManager.location?.coordinate.latitude)!, (locationManager.location?.coordinate.longitude)!)
        let region:MKCoordinateRegion = MKCoordinateRegion(center: newLocation, span: span)
        mapView.setRegion(region, animated: true)
        
        // Hide details page
        annotationDetailsBottomEdge.constant = -250
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    
    
    
    func getAddressfromLatLog(_ annotations: [CustomPointAnnotation]) {
        for annotation in annotations {
//            guard let lat = annotation.lat else {return}
//            guard let lng = annotation.lng else {return}
            if annotation.lat != nil && annotation.lng != nil {
                let lat = annotation.lat!
                let lng = annotation.lng!
                
                let urlString = "https://api.opencagedata.com/geocode/v1/json?q=\(lat)+\( lng)&key=1598abf0be694459b9e15c4f7ca662bd"
                // let urlString = "https://api.myjson.com/bins/h53tt"
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
                    annotation.subtitle = formatted
                })
                task.resume()
            } else {
                print("nil value exit in Annotation")
                
            }
        }
    }

}

