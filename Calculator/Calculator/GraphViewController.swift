//
//  GraphViewController.swift
//  Calculator
//
//  Created by Javier San Juan Cervera on 14/8/15.
//  Copyright (c) 2015 Javier San Juan Cervera. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController, GraphViewDelegate {
    @IBOutlet weak var graphView: GraphView! { didSet { graphView.delegate = self } }
    var calcVC: CalculatorViewController!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        graphView.origin = CGPoint(x:graphView.bounds.size.width/2, y:graphView.bounds.size.height/2)
    }
    
    func valuesForRange(range: Range, step: CGFloat) -> [Double?]? {
        if calcVC == nil || calcVC.canEvaluate() == true {
            return nil
        }
        
        var values = [Double?]()
        for var x = range.min; x <= range.max; x += step {
            values.append(calcVC?.evaluateWithMValue(Double(x)))
        }
        return values
    }
    
    @IBAction func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .Changed {
            graphView.scale *= sender.scale
            sender.scale = 1
        }
    }
    
    @IBAction func pan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .Ended: fallthrough
        case .Changed:
            let translation = sender.translationInView(graphView)
            graphView.origin = CGPoint(x:graphView.origin.x + translation.x, y:graphView.origin.y + translation.y)
            sender.setTranslation(CGPointZero, inView: graphView)
        default: break
        }
    }
    
    @IBAction func doubleTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let location = sender.locationInView(graphView)
            graphView.origin = location
        }
    }
}
