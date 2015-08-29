//
//  AppDelegate.swift
//  Bouncer
//
//  Created by Javier San Juan Cervera on 28/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit
import CoreMotion

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    struct Motion {
        static let Manager = CMMotionManager()
    }
    
    var window: UIWindow?
}
