//
//  ViewController.swift
//  TestHarness
//
//  Copyright © 2018 MapQuest. All rights reserved.
//


import UIKit
import MapQuestMaps
import Mapbox
import MQCore

class ViewController: UIViewController, MGLMapViewDelegate, UIActionSheetDelegate, MQMapViewPOIDelegate, POIDetailsViewDelegate {
  
    let polylineLayerIdentifier:String = "polyline"
    var progressView: UIProgressView!

    var shouldShowPolyline:Bool = false
    @IBOutlet fileprivate weak var mapView: CustomMapView?
    @IBOutlet fileprivate weak var poiDetailsView: POIDetailsView?
    @IBOutlet fileprivate weak var poiDetailsViewTop: NSLayoutConstraint?
    @IBOutlet fileprivate weak var actionButton: UIButton? {
        didSet {
            actionButton?.layer.cornerRadius = 3
            actionButton?.layer.borderColor = UIColor.blue.cgColor
            actionButton?.layer.borderWidth = 0.5
        }
    }
    
    //MARK: - IBAction

    @IBAction fileprivate func actionsButtonTouched(_ sender:UIButton) {
        
        let actionAlertController = UIAlertController(title: "Choose Action", message: "These are some of the examples of what you can do with MapsSDK", preferredStyle: .actionSheet)
        
        actionAlertController.addAction(UIAlertAction(title: "Center Map", style: .default, handler: { (action: UIAlertAction) in
            self.centerMap()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Find Me", style: .default, handler: { (action: UIAlertAction) in
            self.findMe()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Add Annotation", style: .default, handler: { (action: UIAlertAction) in
            self.addAnnotation()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Add Polygon", style: .default, handler: { (action: UIAlertAction) in
            self.addPolygon()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Add Polyline", style: .default, handler: { (action: UIAlertAction) in
            self.addPolyline()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Add Polyline Layer", style: .default, handler: { (action: UIAlertAction) in
            self.addLayerPolyline()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Toggle Map Type", style: .default, handler: { (action: UIAlertAction) in
            self.toggleMapType()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Toggle Traffic", style: .default, handler: { (action: UIAlertAction) in
            self.toggleTraffic()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Clear Map", style: .default, handler: { (action: UIAlertAction) in
            self.clearMap()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Style Buildings", style: .default, handler: { (action: UIAlertAction) in
            self.setBuildingToRed()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Download Map", style: .default, handler: { (action: UIAlertAction) in
            self.downloadMap()
        }))
        
        actionAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction) in
        }))
        self.present(actionAlertController, animated: true, completion: nil)
        
    }
    
    //MARK: - lifecycle methods
    override func viewDidLoad() {
        
        mapView?.mapType = .normal
        if (mapView?.attributionButton.isHidden)! {
            mapView?.attributionButton.isHidden = false
        }
        
        // Setup offline pack notification handlers.
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)

    }
    
    deinit {
        // Remove offline pack observers.
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Actions
    fileprivate func centerMap() {
        //center map on mapquest HQ
        let MAPQUEST_HQ_LOCATION = CLLocationCoordinate2D(latitude: 39.750307, longitude: -104.999472)
        mapView?.setCenter(MAPQUEST_HQ_LOCATION, zoomLevel: 11, animated: true)
    }
    
    fileprivate func findMe()
    {
        mapView?.setUserTrackingMode(.followWithCourse, animated: true)
    }
    
    fileprivate func addAnnotation() {
        //create annotation, add it to the map, then center the map on it using
        //setCenterCoordinate - allows you to customize the zoomlevel
        let  mapQuestHQ = MGLPointAnnotation()
        mapQuestHQ.coordinate = CLLocationCoordinate2D(latitude: 39.750307, longitude: -104.999472)
        mapQuestHQ.title = "MapQuest"
        mapQuestHQ.subtitle = "Welcome to Denver!"

        mapView?.addAnnotation(mapQuestHQ)
        mapView?.setCenter(mapQuestHQ.coordinate, zoomLevel: 12, animated: false)
        
    }
    
    fileprivate func addPolygon() {
        //create polyline, add it to the map, then center on it using showAnnotations
        var coordinates = [
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
        mapView?.addAnnotation(polygon)
        mapView?.showAnnotations([polygon], animated: false)
        mapView?.setZoomLevel(15, animated: true)
    }
    
    fileprivate func addPolyline() {
        //create polyline, add it to the map, then center on it using showAnnotations
        var coordinates = [
            CLLocationCoordinate2D(latitude: 39.74335, longitude: -105.01135),
            CLLocationCoordinate2D(latitude: 39.7468, longitude: -105.00709),
            CLLocationCoordinate2D(latitude: 39.74391, longitude: -105.00794),
            CLLocationCoordinate2D(latitude: 39.7425, longitude: -105.0047),
            CLLocationCoordinate2D(latitude: 39.74634, longitude: -105.00478),
            CLLocationCoordinate2D(latitude: 39.74734, longitude: -104.99984)
        ]
        
        let polyline = MGLPolyline(coordinates: &coordinates, count: UInt(coordinates.count))
        mapView?.addAnnotation(polyline)
        mapView?.showAnnotations([polyline], animated: true)
    }
    
    fileprivate func addLayerPolyline() {
        shouldShowPolyline = true
        if mapView?.style?.layer(withIdentifier: polylineLayerIdentifier) != nil {
            return
        }
        
        //create polyline, add it to the map, then center on it using showAnnotations
        let coordinates = [
            CLLocationCoordinate2D(latitude: 39.74335, longitude: -105.01135),
            CLLocationCoordinate2D(latitude: 39.7468, longitude: -105.00709),
            CLLocationCoordinate2D(latitude: 39.74391, longitude: -105.00794),
            CLLocationCoordinate2D(latitude: 39.7425, longitude: -105.0047),
            CLLocationCoordinate2D(latitude: 39.74634, longitude: -105.00478),
            CLLocationCoordinate2D(latitude: 39.74734, longitude: -104.99984)
        ]
        
        // MGLMapView.style is optional, so you must guard against it not being set.
        guard let style = self.mapView?.style else { return }
        
        let shapeFromGeoJSON = MGLPolyline(coordinates: coordinates, count: UInt(coordinates.count))
        let source = MGLShapeSource(identifier:self.polylineLayerIdentifier, shape: shapeFromGeoJSON, options: nil)
        style.addSource(source)
        
        // Create new layer for the line.
        let layer = MGLLineStyleLayer(identifier:self.polylineLayerIdentifier, source: source)
        
        // Set the line join and cap to a rounded end.
        layer.lineJoin = NSExpression(forConstantValue: "round")
        layer.lineCap = NSExpression(forConstantValue: "round")
        
        // Set the line color to a constant blue color.
        layer.lineColor = NSExpression(forConstantValue: UIColor(red: 59/255, green:178/255, blue:208/255, alpha:1))
        
        // Use `NSExpression` to smoothly adjust the line width from 2pt to 20pt between zoom levels 14 and 18. The `interpolationBase` parameter allows the values to interpolate along an exponential curve.
        layer.lineWidth = NSExpression(format: "mgl_interpolate:withCurveType:parameters:stops:($zoomLevel, 'linear', nil, %@)",
                                       [14: 2, 18: 20])
        style.addLayer(layer)
        
        let camera:MGLMapCamera = MGLMapCamera(lookingAtCenter:CLLocationCoordinate2D(latitude: 39.74391, longitude: -105.00794), fromDistance: 1000, pitch: 65, heading: 0)
        
        mapView?.fly(to: camera, completionHandler: {})
    }
    
    fileprivate func toggleMapType() {
        //toggle the map between normal and satellite
        mapView?.mapType = mapView?.mapType == .normal ? .satellite : .normal
    }
    
    fileprivate func toggleTraffic() {
        //centers the map on nyc (zoomed in a bit so you can see traffic) then toggles traffic
        centerMap()
        if let map = mapView {
            map.shouldShowTrafficFlows = true
            map.shouldShowTrafficCameras = false
            map.shouldShowTrafficIncidents = true
            map.trafficEnabled = !map.trafficEnabled
        }
    }
    
    fileprivate func clearMap() {
        //put map back into its orginal state when first launched
        if let map = mapView {
            if let annotations = map.annotations {
                map.removeAnnotations(annotations)
            }
            
            shouldShowPolyline = false
            map.setUserTrackingMode(.none, animated: false)
            map.mapType = .normal
            map.trafficEnabled = false;
            map.setZoomLevel(0, animated: true)
        }
    }
    
    fileprivate func downloadMap() {
        // Create a region that includes the current viewport and any tiles needed to view it when zoomed further in.
        // Because tile count grows exponentially with the maximum zoom level, you should be conservative with your `toZoomLevel` setting.
        let region = MGLTilePyramidOfflineRegion(styleURL: mapView?.styleURL, bounds: (mapView?.visibleCoordinateBounds)!, fromZoomLevel: (mapView?.zoomLevel)!, toZoomLevel: 16)
        
        // Store some data for identification purposes alongside the downloaded resources.
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        // Create and register an offline pack with the shared offline storage object.
        
        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            // Start downloading.
            pack!.resume()
        }
    }
    
    fileprivate func setBuildingToRed() {
        guard let style = self.mapView?.style else {return}
        
        guard let buildingLayer:MGLFillStyleLayer = style.layer(withIdentifier: "building") as? MGLFillStyleLayer else {return}
        
        buildingLayer.fillColor = NSExpression(forConstantValue: UIColor.red)
    }
    
    //
    // MARK: - MGLOfflinePack notification handlers
    
    @objc func offlinePackProgressDidChange(notification: NSNotification) {
        
        // Get the offline pack this notification is regarding,
        // and the associated user info for the pack; in this case, `name = My Offline Pack`
        if let pack = notification.object as? MGLOfflinePack {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            // Calculate current progress percentage.
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            // Setup the progress bar.
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
                view.addSubview(progressView)
            }
            
            progressView.progress = progressPercentage
        }
    }
    
    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }
    
    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
        }
    }
    //MARK: - MQMapViewPOIDelegate
    func mapView(_ mapView: MGLMapView, didTapOnPOI poi: MQNamedPlace!) {
        poiDetailsView?.updatePOIDetails(poi)
        toggleDetailView()
    }
    
    //MARK: -  POIDetailsViewDelegate
    func toggleDetailView() {
        if poiDetailsViewTop?.constant == 0 {
            poiDetailsViewTop?.constant = (poiDetailsView?.frame.size.height)! * -1
        }else {
            poiDetailsViewTop?.constant = 0
        }
    }
    
    
    //MARK: - MapView delegates
    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {
        if shouldShowPolyline {
            addLayerPolyline()
        }
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
    
    func mapView(_ mapView: MGLMapView, viewFor annotation: MGLAnnotation) -> MGLAnnotationView? {
        
        if annotation is MGLUserLocation {
        
            // For better performance, always try to reuse existing annotations.
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "userAnnotation")
        
            if annotationView == nil {
                
                //create a new annotation view
                annotationView =  MGLUserLocationAnnotationView(reuseIdentifier: "userAnnotation")
                
                annotationView?.frame = CGRect(x: 0, y: 0, width: 40 , height: 40)
                
                let userLocationAnnotationImageView = UIImageView(frame: CGRect(x: 0, y: 0, width:40, height: 40))
                let userLocationAnnotationImage = UIImage(named: "icon_spaceship")
                userLocationAnnotationImageView.image = userLocationAnnotationImage
                
                //add image to annotation
                annotationView?.addSubview(userLocationAnnotationImageView)
                
                return annotationView;
            }
        }
        return nil;
    }
    
    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat {
        return 1
    }
    
    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> UIColor {
        return UIColor.blue
    }
    
    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> UIColor {
        return UIColor.orange
        
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        if annotation is MGLUserLocation {
            let userAnnotationImage = MGLAnnotationImage(image:  UIImage(imageLiteralResourceName: "icon_spaceship.png"), reuseIdentifier: "userAnnotation")
            
            return userAnnotationImage
        }
        return nil
    }
}

