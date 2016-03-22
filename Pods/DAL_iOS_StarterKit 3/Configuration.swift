//
//  Configuration.swift
//  DAL_iOS_StarterKit
//
//  Created by Thulasingam, Bhakeeswaran on 2/16/16.
//  Copyright © 2016 Amgen. All rights reserved.
//

import Foundation

class ConfigSettings {
    
    class var sharedInstance: ConfigSettings {
        struct Singleton {
            static let instance = ConfigSettings()
        }
        return Singleton.instance
    }
    
    private var configSettings: NSDictionary!
    
    required init() {
        let filePath = NSBundle.mainBundle().pathForResource("Configuration", ofType: "plist")!
        self.configSettings = NSDictionary(contentsOfFile:filePath)
    }
    
    var NewRelicToken: String {
        get {
            return configSettings["NewRelicToken"] as! String
        }
    }
    
    var AppStoreURL: String {
        get {
            return configSettings["AppStoreURL"] as! String
        }
    }
    
    var AppInfoContent: String {
        get {
            return configSettings["AppInfoContent"] as! String
        }
    }
    
    var DALEmail: String {
        get {
            return configSettings["DALEmail"] as! String
        }
    }
    
    var AppTitle: String {
        get {
            return configSettings["AppTitle"] as! String
        }
    }

    var EmailSettings: NSDictionary {
        get {
            return configSettings["EmailSettings"] as! NSDictionary
        }
    }
    
}