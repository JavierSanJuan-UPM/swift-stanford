//
//  EditWaypointViewController.swift
//  Trax
//
//  Created by Javier San Juan Cervera on 28/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class EditWaypointViewController: UIViewController, UITextFieldDelegate {
    var waypointToEdit: EditableWaypoint? { didSet { updateUI() } }
    
    @IBOutlet weak var nameTextField: UITextField! { didSet { nameTextField.delegate = self } }
    @IBOutlet weak var infoTextField: UITextField! { didSet { infoTextField.delegate = self } }
    
    func updateUI() {
        nameTextField?.text = waypointToEdit?.name
        infoTextField?.text = waypointToEdit?.info
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    @IBAction func done(sender: UIBarButtonItem) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        nameTextField.becomeFirstResponder()
        observeTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        let center = NSNotificationCenter.defaultCenter()
        if let observer = nameTextFieldObserver { center.removeObserver(observer) }
        if let observer = infoTextFieldObserver { center.removeObserver(observer) }
    }
    
    var nameTextFieldObserver: NSObjectProtocol?
    var infoTextFieldObserver: NSObjectProtocol?
    
    func observeTextFields() {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        nameTextFieldObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: nameTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.name = self.nameTextField.text
            }
        }
        infoTextFieldObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: infoTextField, queue: queue) { notification in
            if let waypoint = self.waypointToEdit {
                waypoint.info = self.infoTextField.text
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
