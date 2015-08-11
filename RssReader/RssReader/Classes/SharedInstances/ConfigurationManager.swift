//
//  ConfigurationManager.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//
import UIKit


class ConfigurationManager: NSObject {
    var configuration:AnyObject?
    lazy var feeds: [[String: String]] = ConfigurationManager.initFeeds()

    override init() {
        super.init()
        
        if let confPath = NSBundle.mainBundle().pathForResource("ReaderConf", ofType: "plist") {
            configuration = NSDictionary(contentsOfFile: confPath)
        }
    }
    
    class func sharedConfigurationManager() -> ConfigurationManager {
        return _sharedConfigurationManager
    }
    
    class func initFeeds() -> [[String: String]] {
        return ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("Feeds") as! [[String: String]]
        
    }
    
    class func isDetailViewAdsEnabled() -> Bool {
        return ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("DetailViewAdsEnabled") as! Bool
    }

    class func isHomeScreenAdsEnabled() -> Bool {
        return ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("HomeScreenAdsEnabled") as! Bool
    }

    class func isDropdownMenuEnabled() -> Bool {
        return ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("DropdownMenu") as! Bool
    }
    
    class func displayMode() -> String {
        return ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("DisplayMode") as! String
    }
    
    class func defaultCellFont() -> String {
        if let defaultFont = ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("DefaultCellFont") as? String{

            return defaultFont
        }
        
        return "Raleway"
    }

    class func defaultBarFont() -> String {
        
        if let defaultFont = ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("DefaultBarFont") as? String {
            return defaultFont
        }
        
        return "Coustard-Regular"
    }

    class func defaultTheme() -> String {
        
        if let defaultTheme = ConfigurationManager.sharedConfigurationManager().configuration?.objectForKey("Theme") as? String {
            return defaultTheme
        }
        
        return "Dark"
    }

}

let _sharedConfigurationManager: ConfigurationManager = { ConfigurationManager() }()