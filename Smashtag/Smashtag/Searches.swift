//
//  Searches.swift
//  Smashtag
//
//  Created by Javier San Juan Cervera on 28/8/15.
//  Copyright (c) 2015 Pulse. All rights reserved.
//

import Foundation

class Searches {
    class func addSearch(search: String) {
        var searchesArr = searches
        
        if let index = find(searchesArr, search) {
            searchesArr.removeAtIndex(index)
        }
        
        searchesArr.insert(search, atIndex: 0)
        
        while searchesArr.count > max {
            searchesArr.removeLast()
        }
        
        searches = searchesArr
    }
    
    class var searches: [String] {
        get { return defaults.objectForKey(searchesKey) as? [String] ?? [] }
        set { defaults.setObject(newValue, forKey: searchesKey) }
    }
    
    private static let defaults = NSUserDefaults.standardUserDefaults()
    private static let searchesKey = "Smashtag.Searches"
    private static let max = 100
    
    private init() {
    }
}