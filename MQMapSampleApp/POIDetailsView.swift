//
//  POIDetailsView.swift
//  TestHarness
//
//  Created by amudubagilu on 6/25/18.
//  Copyright © 2018 MapQuest. All rights reserved.
//

import Foundation
import UIKit
import MQCore

protocol POIDetailsViewDelegate {
    func toggleDetailView()
}

class POIDetailsView: UIView {
    var delegate : Any?
    
    @IBOutlet fileprivate var name:UILabel?
    @IBOutlet fileprivate var address:UILabel?
    @IBOutlet fileprivate var address2:UILabel?
    
    @IBAction func close(sender:Any) {
        if let delegate = delegate as? POIDetailsViewDelegate {
            delegate.toggleDetailView()
        }
    }
    
    func updatePOIDetails(_ poi:MQNamedPlace) {
        name?.text = (poi.name != nil) ? poi.name : ""
        address?.text = (poi.geoAddress?.street != nil) ? poi.geoAddress?.street:""
        
        var address2String = ""
        if let city = poi.geoAddress?.city {
             address2String += city + ", "
        }
        if  let state = poi.geoAddress?.state {
            address2String += state
        }
        if let zip = poi.geoAddress?.zip {
            address2String += "-" + zip
        }
        
        address2?.text = address2String
    }
    
}
