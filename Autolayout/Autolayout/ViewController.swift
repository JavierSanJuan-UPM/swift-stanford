//
//  ViewController.swift
//  Autolayout
//
//  Created by Javier San Juan Cervera on 8/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lastLoginLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    private struct AlertStrings {
        struct LoginError {
            static let Title = NSLocalizedString("Login Error", comment: "Title of alert when user types in an incorrect username or password")
            static let Message = NSLocalizedString("Invalid username of password", comment: "Message in an alert when the user types in an incorrect username or password")
            static let DismissButton = NSLocalizedString("Try Again", comment: "The only button available in an alert presented when the user types incorrect username or password")
        }
    }
    
    var loggedInUser: User? { didSet { updateUI() } }
    var secure = false { didSet { updateUI() } }
    
    private func updateUI() {
        passwordField.secureTextEntry = secure
        let password = NSLocalizedString("Password", comment: "Prompt for the user's password when it is not secure")
        let securedPassword = NSLocalizedString("Secure Password", comment: "Prompt for the user's password when it is secure")
        passwordLabel.text = secure ? securedPassword : password
        nameLabel.text = loggedInUser?.name
        companyLabel.text = loggedInUser?.company
        image = loggedInUser?.image
        if let lastLogin = loggedInUser?.lastLogin {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.dateStyle = NSDateFormatterStyle.NoStyle
            let time = dateFormatter.stringFromDate(lastLogin)
            
            let numberFormatter = NSNumberFormatter()
            numberFormatter.maximumFractionDigits = 1
            let daysAgo = numberFormatter.stringFromNumber(-lastLogin.timeIntervalSinceNow/(60*60*24))
            
            let lastLoginFormatString = NSLocalizedString("Last Login %@ days ago at %@", comment: "Reports the number of days and time when the user last logged in")
            lastLoginLabel.text = String.localizedStringWithFormat(lastLoginFormatString, daysAgo!, time)
        } else {
            lastLoginLabel.text = ""
        }
    }
    
    @IBAction func toggleSecurity() {
        secure = !secure
    }
    
    @IBAction func login() {
        loggedInUser = User.login(loginField.text ?? "", password: passwordField.text ?? "")
        if loggedInUser == nil {
            let alert = UIAlertController(title: AlertStrings.LoginError.Title, message: AlertStrings.LoginError.Message, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: AlertStrings.LoginError.DismissButton, style: UIAlertActionStyle.Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        } else {
            loggedInUser?.lastLogin = NSDate()
        }
    }
    
    var aspectRatioConstraint: NSLayoutConstraint? {
        willSet {
            if let oldConstraint = aspectRatioConstraint {
                view.removeConstraint(oldConstraint)
            }
        }
        didSet {
            if aspectRatioConstraint != nil {
                view.addConstraint(aspectRatioConstraint!)
            }
        }
    }
    
    var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            if let constrainedView = imageView {
                if let newImage = newValue {
                    aspectRatioConstraint = NSLayoutConstraint(
                        item: constrainedView,
                        attribute: .Width,
                        relatedBy: .Equal,
                        toItem: constrainedView,
                        attribute: .Height,
                        multiplier: newImage.aspectRatio,
                        constant: 0)
                } else {
                    aspectRatioConstraint = nil
                }
            }
        }
    }
}

extension User {
    var image: UIImage? {
        if let image = UIImage(named: login) {
            return image
        } else {
            return UIImage(named: "unknown_user")
        }
    }
}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
