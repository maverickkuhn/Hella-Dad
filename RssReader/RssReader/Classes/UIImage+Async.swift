//
//  UIImage+Async.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//
import UIKit

extension UIImage {
    
    func asyncGetImage(url: NSURL, completionHandler: ((data: NSData?, error: NSError?) -> Void)) {
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            completionHandler(data: data, error: error)
        }).resume()
    }
}