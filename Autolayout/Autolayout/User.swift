//
//  User.swift
//  Autolayout
//
//  Created by Javier San Juan Cervera on 8/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import Foundation

struct User {
    let name: String
    let company: String
    let login: String
    let password: String
    var lastLogin: NSDate?
    
    init(name: String, company: String, login: String, password: String) {
        self.name = name
        self.company = company
        self.login = login
        self.password = password
        self.lastLogin = nil
    }
    
    static func login(login: String, password: String) -> User? {
        if let user = database[login] {
            if user.password == password {
                return user
            }
        }
        return nil
    }
    
    static let database: [String: User] = {
        var theDatabase = [String: User]()
        for user in [
            User(name: "Javier San Juan", company: "U-tad", login: "javi", password: "1234"),
            User(name: "Álvaro San Juan", company: "UPM", login: "also", password: "1234"),
            User(name: "Montserrat Cervera", company: "Estudio", login: "montse", password:"1234")
        ] {
            theDatabase[user.login] = user
        }
        return theDatabase
    }()
}