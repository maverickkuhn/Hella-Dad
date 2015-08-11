//
//  Article.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import Foundation

class Article {
    var link: String? = ""
    var categories = [String]()
    var headerImageURL: String? = "" {
        didSet {
            headerImageURL = headerImageURL?.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            headerImageURL = headerImageURL?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            headerImageURL = headerImageURL?.stringByReplacingOccurrencesOfString("&amp;", withString: "&")
        }
    }
    var commentsCount = 0
    var authorName: String? = ""
    var title: String? = "" {
        didSet {
            title = title?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        }
    }
    var isFavorite = false
    var publicationDate = NSDate()
    var description: String? = ""
    var rawDescription: String? = "" /*{
        didSet {
            description = rawDescription?.stringByDecodingHTMLEscapeCharacters()
        }
    }*/
    var readAt: NSDate?
    var favoritedAt: NSDate?
    var content: String? = ""
    var guid: String? = ""
    
    init() {

    }
}