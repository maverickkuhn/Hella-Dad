//
//  NSMutableAttributedString+HTML.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import Foundation

extension NSMutableAttributedString {
    
    func removeHTMLTags() {
        replaceAllStrings("<[^>]+>", replacement: "")
    }
    
    func replaceAllStrings(pattern: String, replacement: String) {
        var range = (self.string as NSString).rangeOfString(pattern, options: .RegularExpressionSearch)
        while range.location != NSNotFound {
            self.replaceCharactersInRange(range, withString: replacement)
            range = (self.string as NSString).rangeOfString(pattern, options: .RegularExpressionSearch)
        }
    }
}