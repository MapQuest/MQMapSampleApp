//
//  ViewController.swift
//  MQSimpleiOSMap
//
//  Created by Bannikodu, Rashmi on 5/10/17.
//  Copyright © 2017 Bannikodu, Rashmi. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController, MGLMapViewDelegate {
    
    @IBOutlet var mapView: MQMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView?.mapType = .normal
        //mapView?.mapType = .nightMode
        mapView?.trafficEnabled = true
        //mapView?.userTrackingMode = .follow
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Set the Map to a Latitude/Longitude
        /*let nyc = CLLocationCoordinate2D(latitude: 40.7326808, longitude: -73.9843407)
        mapView?.setCenter(nyc, zoomLevel: 11, animated: true)*/
        
        //Add a marker on the map
        let sanFran = MGLPointAnnotation()
        sanFran.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        sanFran.title = "San Francisco"
        sanFran.subtitle = "Welcome to San Fran"
        
        mapView?.addAnnotation(sanFran)
        mapView?.setCenter(sanFran.coordinate, zoomLevel:10, animated: true)
        
        //Put a Polygon on the Map
        /*var coordinates = [
            CLLocationCoordinate2DMake(39.744465080845458,-105.02038957961648),
            CLLocationCoordinate2DMake(39.744460864711129,-105.01981090977684),
            CLLocationCoordinate2DMake(39.744379574636383,-105.01970518778262),
            CLLocationCoordinate2DMake(39.743502042120781,-105.01970874744497),
            CLLocationCoordinate2DMake(39.743419794549339,-105.01977839958302),
            CLLocationCoordinate2DMake(39.74341214360723,-105.02038412442006),
            CLLocationCoordinate2DMake(39.74349726029007,-105.02049233399056),
            CLLocationCoordinate2DMake(39.744393745651706,-105.0204836274754)
        ]
        
        let polygon = MGLPolygon(coordinates: &coordinates, count: UInt(coordinates.count))
        polygon.title = "MY TEST POLYGON"
        mapView?.addAnnotation(polygon)
        mapView?.showAnnotations([polygon], animated: true)*/
        
    }
    
    // Tapping the annotation
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        // Always try to show a callout when an annotation is tapped.
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

