//
//  Car.swift
//  Ridecell-Demo
//
//  Created by Jangey Lu on 6/20/19.
//  Copyright © 2019 Jangey Lu. All rights reserved.
//

import Foundation

class Car {
    var id: Int
    var is_active: Bool
    var is_available: Bool
    var lat: Double
    var license_plate_number: String
    var lng: Double
    var pool: String
    var remaining_mileage: Int
    var remaining_range_in_meters: Int
    var transmission_mode: String
    var vehicle_make: String
    var vehicle_pic: String
    var vehicle_pic_absolute_url: URL
    var vehicle_type: String
    var vehicle_type_id: Int
    
    init(json: [String: Any]) {
        id = json["id"] as? Int ?? -1
        is_active = json["is_active"] as? Bool ?? false
        is_available = json["is_available"] as? Bool ?? false
        lat = json["lat"] as? Double ?? 0
        license_plate_number = json["license_plate_number"] as? String ?? "No license plate number"
        lng = json["lng"] as? Double ?? 0
        pool = json["pool"] as? String ?? "No pool"
        remaining_mileage = json["remaining_mileage"] as? Int ?? 0
        remaining_range_in_meters = json["remaining_range_in_meters"] as? Int ?? 0
        transmission_mode = json["transmission_mode"] as? String ?? "No transmission mode"
        vehicle_make = json["vehicle_make"] as? String ?? "No vehicle make"
        vehicle_pic = json["vehicle_pic"] as? String ?? "No vehicle pic"
        vehicle_pic_absolute_url = json["vehicle_pic_absolute_url"] as? URL ?? URL(string: "https://ridecell.com/wp-content/themes/ridecell2017/images/Ridecell_logotype.svg")!
        vehicle_type = json["vehicle_type"] as? String ?? "No vehicle type"
        vehicle_type_id = json["vehicle_type_id"] as? Int ?? 0
    }
}
