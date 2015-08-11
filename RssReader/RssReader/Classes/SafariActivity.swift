//
//  SafariActivity.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

class SafariActivity: UIActivity {
    private var url:NSURL?
   
    override func activityType() -> String? {
        return "SafariActivity"
    }
    
    override func activityTitle() -> String? {
        return "Open in Safari"
    }
    
    override func activityImage() -> UIImage? {
        let safariImage = UIImage(named: "safari-7")
        return safariImage
    }
    
    override func canPerformWithActivityItems(activityItems: [AnyObject]) -> Bool {
        for activityItem in activityItems {
            if let activityItem = activityItem as? NSURL where UIApplication.sharedApplication().canOpenURL(activityItem) {
                return true
            }
        }
        
        return false
    }
    
    override func prepareWithActivityItems(activityItems: [AnyObject]) {
        for activityItem in activityItems {
            if let activityItem = activityItem as? NSURL {
                url = activityItem
            }
        }
    }
    
    override func performActivity() {
        let completed = UIApplication.sharedApplication().openURL(url!)
        activityDidFinish(completed)
    }
}
