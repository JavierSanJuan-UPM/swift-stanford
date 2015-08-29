//
//  WaypointImageViewController.swift
//  Trax
//
//  Created by Javier San Juan Cervera on 29/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class WaypointImageViewController: ImageViewController {
    var mapViewController: SimpleMapViewController?
    
    var waypoint: GPX.Waypoint? {
        didSet {
            imageURL = waypoint?.imageURL
            title = waypoint?.name
            updateEmbeddedMap()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Embed Map" {
            mapViewController = segue.destinationViewController as? SimpleMapViewController
            updateEmbeddedMap()
        }
    }
    
    func updateEmbeddedMap() {
        if let mapView = mapViewController?.mapView {
            mapView.mapType = .Hybrid
            mapView.removeAnnotations(mapView.annotations)
            mapView.addAnnotation(waypoint)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
}
