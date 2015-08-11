//
//  SFMenuItem.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//
import Foundation

class DropdownMenuItem: REMenuItem {
    var url: NSURL?
    
    override init!(title: String!, image: UIImage!, highlightedImage: UIImage!, action: ((REMenuItem!) -> Void)!) {
        super.init(title: title, image: image, highlightedImage: highlightedImage, action: action)
    }
}