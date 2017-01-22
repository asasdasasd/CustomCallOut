//
//  CustomAnnotation.swift
//  CustomCallOutDemo
//
//  Created by shen
//  Copyright © 2016年 shen. All rights reserved.
//

import MapKit

class CustomAnnotation: NSObject,MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var annoModels: [AnnoModel]?

    init(coordinate: CLLocationCoordinate2D, models: Array<AnnoModel>) {
        self.coordinate = coordinate
        self.annoModels = models
    }
    
}
