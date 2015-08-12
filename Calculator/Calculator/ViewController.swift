//
//  ViewController.swift
//  Calculator
//
//  Created by Javier San Juan Cervera on 20/7/15.
//  Copyright (c) 2015 Javier San Juan Cervera. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var history: UILabel!
    var isInMiddleOfTyping = false
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        // Handle π as a special case
        if sender.currentTitle! == "π" {
            // Enter the number we were typing (if any)
            if isInMiddleOfTyping { enter() }
            
            // Set display to π
            display.text = "\(M_PI)"
            
            // Enter π
            enter();
        } else {
            // Get digit
            let digit = sender.currentTitle!
            
            // If we are typing a number, append to it
            if isInMiddleOfTyping {
                // Control that we only append a dot once
                if digit != "." || digit == "." && display.text!.rangeOfString(".") == nil {
                    display.text = display.text! + digit
                }
                // Otherwise, replace by new digit
            } else {
                // If we enter a dot, append it to the 0
                display.text = (digit == ".") ? "0." : digit
                
                // We have started to enter a number
                isInMiddleOfTyping = true
            }
        }
    }
    
    @IBAction func backspace() {
        if isInMiddleOfTyping {
            display.text = dropLast(display.text!)
            if count(display.text!) == 0 {
                isInMiddleOfTyping = false
                display.text = "0"
            }
        } else {
            display.text = "0"
        }
    }
    
    @IBAction func operate(sender: UIButton) {
        if isInMiddleOfTyping { enter() }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
                history.text = brain.description + "="
            } else {
                displayValue = nil
                history.text = brain.description
            }
        }
    }

    @IBAction func enter() {
        isInMiddleOfTyping = false
        if let result = brain.pushOperand(displayValue!) {
            displayValue = result
        } else {
            displayValue = 0
        }
        //appendHistory("\(displayValue!)")
        history.text = brain.description
    }
    
    var displayValue: Double? {
        get {
            if let displayText = display.text {
                if let valueNumber = NSNumberFormatter().numberFromString(displayText) {
                    return valueNumber.doubleValue
                } else {
                    println("Cannot get double from: \(displayText)")
                    return nil
                }
            } else {
                return nil
            }
        }
        set {
            if newValue != nil {
                display.text = "\(newValue!)"
            } else {
                display.text = " "
            }
        }
    }
    
    @IBAction func clear() {
        display.text = "0"
        history.text = " "
        isInMiddleOfTyping = false
        brain.clearStack()
        brain.variableValues["M"] = nil
    }
    
    @IBAction func changeSign(sender: UIButton) {
        if isInMiddleOfTyping {
            if let theValue = displayValue {
                displayValue = theValue
            } else {
                println("Cannot change the sign of nil")
            }
        } else {
            operate(sender)
        }
    }
    
    @IBAction func setM() {
        if let value = displayValue {
            brain.variableValues["M"] = value
            isInMiddleOfTyping = false
        }
        displayValue = brain.evaluate()
        history.text = brain.description
    }
    
    @IBAction func getM() {
        if isInMiddleOfTyping { enter() }
        if let result = brain.pushOperand("M") {
            displayValue = result
        }
        history.text = brain.description
    }
    
    /*func appendHistory(value: String) {
        // Store trimmed string
        var oldText = history.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) ?? ""
        
        // Remove trailing "=" if it exists
        if count(oldText) > 0 && oldText[advance(oldText.startIndex, count(oldText)-1)] == "=" { oldText = dropLast(oldText) }
        
        // Append comma if not empty
        if count(oldText) > 0 { oldText += ", " }
        
        // Append value
        history.text = oldText + value
    }*/
}
