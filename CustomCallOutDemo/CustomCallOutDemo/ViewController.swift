//
//  ViewController.swift
//  CustomCallOutDemo
//
//  Created by shen
//  Copyright © 2016年 shen. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.delegate = self
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 31.0783492704, longitude: 121.5217394820), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        self.mapView.setRegion(region, animated: true)
     
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let url = URL(fileURLWithPath: path!)
        let jsonData = try! Data.init(contentsOf: url)
        if JSONSerialization.isValidJSONObject(jsonData) {
            return
        }
        let json = try! JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.mutableContainers) as! [[String: Any]]
        
        print(json)
        let modelArray: [AnnoModel] = json.map({AnnoModel.init(json: $0)})
        
        let sortedDict = modelArray.categorise{$0.address}
        
        for (key,value) in sortedDict{
            
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString("上海市\(key)", completionHandler: { (placemarks, error) in
                guard error == nil, placemarks?.count != 0 else{
                    print(error.debugDescription)
                    return
                }
                let placemark = placemarks?.first
                let coordinate = placemark?.location?.coordinate
                
                let annotation = CustomAnnotation(coordinate:coordinate!, models: value)
                
                self.mapView.addAnnotation(annotation)
            })
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "annotation")
        
        if annotationView == nil {
            annotationView = AnnotationView(annotation: annotation, reuseIdentifier: "annotation")
        }else{
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
        if view.annotation is MKUserLocation {
            return
        }
        
        let customAnnotation = view.annotation as! CustomAnnotation
        
        let calloutView = CustomCallOut.init(customAnnotation.annoModels!)
        let size: CGSize = calloutView.layout(models: customAnnotation.annoModels!)
        calloutView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        calloutView.center = CGPoint(x: view.bounds.size.width / 2, y: -calloutView.bounds.size.height*0.52)
        view.addSubview(calloutView)
        
        mapView.setCenter((view.annotation?.coordinate)!, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        if view.isKind(of: AnnotationView.self) {
            for subview in view.subviews {
                subview.removeFromSuperview()
            }
        }
    }
}
