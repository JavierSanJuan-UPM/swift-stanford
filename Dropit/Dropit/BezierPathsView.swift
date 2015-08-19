//
//  BezierPathsView.swift
//  Dropit
//
//  Created by Javier San Juan Cervera on 19/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class BezierPathsView: UIView {
    var bezierPaths = [String:UIBezierPath]()
    
    func setPath(path: UIBezierPath?, named name: String) {
        bezierPaths[name] = path
        setNeedsDisplay()
    }

    override func drawRect(rect: CGRect) {
        for (_, path) in bezierPaths {
            path.stroke()
        }
    }
}
