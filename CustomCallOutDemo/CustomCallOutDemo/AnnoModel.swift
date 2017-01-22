//
//  AnnoModel.swift
//  CustomCallOutDemo
//
//  Created by shen
//  Copyright © 2016年 shen. All rights reserved.
//
import Foundation
import MapKit

struct AnnoModel {
    
    var address: String
    let name: String?
    let time: String?
    let dates: [String]?
    let projectName: String?
    var coordinate: CLLocationCoordinate2D?
    
    init(json:[String: Any]) {
        address = json["PROJECT_ADDRESS"] as! String
        name = json["SG_NAME"] as! String?
        time = json["FTDATE"] as! String?
        dates = time?.components(separatedBy: ",")
        dates?.removeLast()
        projectName = json["PROJECT_NAME"] as! String?
    }
    
    
}

