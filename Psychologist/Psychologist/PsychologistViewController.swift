//
//  ViewController.swift
//  Psychologist
//
//  Created by Javier San Juan Cervera on 7/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class PsychologistViewController: UIViewController {

    @IBAction func nothing(sender: UIButton) {
        performSegueWithIdentifier("Diagnose Nothing", sender: sender)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let navVC = segue.destinationViewController as? UINavigationController {
            if let hvc = navVC.visibleViewController as? HappinessViewController {
                if let identifier = segue.identifier {
                    switch identifier {
                    case "Diagnose Sad": hvc.happiness = 0
                    case "Diagnose Happy": hvc.happiness = 100
                    case "Diagnose Nothing": hvc.happiness = 25
                    default: hvc.happiness = 50
                    }
                }
            }
        }
    }

}

