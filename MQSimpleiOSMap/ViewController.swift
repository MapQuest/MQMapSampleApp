//
//  ViewController.swift
//  MQSimpleiOSMap
//
//  Created by Bannikodu, Rashmi on 5/10/17.
//  Copyright © 2017 Bannikodu, Rashmi. All rights reserved.
//

import UIKit
import Mapbox

class ViewController: UIViewController {
    
    @IBOutlet var mapView: MQMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView?.mapType = .normal
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

