//
//  GraphView.swift
//  Calculator
//
//  Created by Javier San Juan Cervera on 14/8/15.
//  Copyright (c) 2015 Javier San Juan Cervera. All rights reserved.
//

import UIKit

@IBDesignable
class GraphView: UIView {
    weak var delegate: GraphViewDelegate?
    var origin = CGPoint(x: 0, y: 0) { didSet { self.setNeedsDisplay() } }
    @IBInspectable var scale: CGFloat = 1 { didSet { self.setNeedsDisplay() } }
    
    private var drawer = AxesDrawer(color: UIColor.blueColor())
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        // Define the range of x (M) values to calculate
        let range = Range(min: -origin.x / scale, length: rect.size.width / scale)
        
        // Define the step in which we want to calculate values (every 5 screen pixels)
        let step: CGFloat = range.length / (rect.size.width / 5)
        
        // Check if we can obtain an array or values
        if let values = delegate?.valuesForRange(range, step: step) {
            // Define the step in which we want to draw values
            let drawStep = rect.size.width / CGFloat(values.count)
            
            // Define drawing point
            var point = CGPoint(x: 0, y: 0)
            
            // Create bezier path
            let bezierPath = UIBezierPath()
            
            // Add lines to all other points
            var lastNil = true
            for var i = 0; i < values.count; ++i {
                if values[i] == nil {
                    lastNil = true
                } else {
                    // Calculate y
                    point.y = origin.y + CGFloat(-values[i]!) * scale
                    
                    if lastNil {
                        // Move to first value in path
                        bezierPath.moveToPoint(point)
                    } else {
                        // Add line to bezier path
                        bezierPath.addLineToPoint(point)
                    }
                    
                    lastNil = false
                }
                
                // Increment x
                point.x += drawStep
            }
            UIColor.greenColor().set()
            bezierPath.stroke()
        }
        drawer.drawAxesInRect(rect, origin: origin, pointsPerUnit: scale)
    }
}

protocol GraphViewDelegate : class {
    func valuesForRange(range: Range, step: CGFloat) -> [Double?]?
}

struct Range: Printable {
    var min: CGFloat
    var max: CGFloat
    var length: CGFloat { return max - min }
    
    init(min: CGFloat, max: CGFloat) {
        self.min = min
        self.max = max
    }
    
    init(min: CGFloat, length: CGFloat) {
        self.min = min
        self.max = min + length
    }
    
    var description: String { return "(min: \(min), max: \(max))" }
}