//
//  MapViewController.swift
//  UIUTestExample
//
//  Created by Tyler Thompson on 5/28/19.
//  Copyright © 2019 Purgatory Design. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class MapViewController: UIViewController {
    @IBOutlet var mapView:MKMapView!
    
    override public func viewDidLoad() {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.centerCoordinate
        mapView.addAnnotation(annotation)        
    }
}

extension MapViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        return MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
    }
    
    public func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let alert = UIAlertController(title: "Ouch! You hit me", message: nil, preferredStyle: .alert)
        alert.addAction(.init(title: "Get over it", style: .default))
        present(alert, animated: true)
    }
}
