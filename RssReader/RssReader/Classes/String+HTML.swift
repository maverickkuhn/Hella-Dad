//
//  String+HTML.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//
import Foundation

private let characterEntities:[String: String] = [
    "&nbsp;" : "",
    "&quot;" : "\"",
    "&apos;" : "'",
    "&amp;" : "&",
    "&lt;": "<",
    "&gt;": ">",
    "&hellip;": "...",
    "&ldquo;": "\"",
    "&rdquo;": "\"",
    "&aacute;": "á",
    "&xe1c;": "á",
    "&eacute;": "é",
    "&iacute;": "í",
    "&xed;": "í",
    "&oacute;": "ó",
    "&uacute;": "ú",
    "&ntilde;": "ñ",
    "&xf1;": "ñ",
    "&copy;" : "\u{00A9}",
    "&lsquo;" : "'",
    "&rsquo;" : "'",
    "&ndash;" : "-",
    "&#34;": "\"",
    "&#35;": "#",
    "&#36;": "$",
    "&#37;": "%",
    "&#38;": "&",
    "&#39;": "'",
    "&#46;": ".",
    "&#034;": "\"",
    "&#035;": "#",
    "&#036;": "$",
    "&#037;": "%",
    "&#038;": "&",
    "&#039;": "'",
    "&#046;": ".",
    "&#124;": "|",
    "&#160;": " ",
    "&#8211;": "-",
    "&#8217;": "'",
    "&#8220;": "\"",
    "&#8221;": "\"",
    "&#8212;": "—",
    "&#8216;": "'",
    "&#8230;": "...",
    "&#8243;": "\"",
    "&#8594;": "→"
]

extension String {
    
    func stringByConvertingFromHTML() -> String {
        let encodedData = self.dataUsingEncoding(NSUTF8StringEncoding)!
        let attributedOptions : [String: AnyObject] = [
            NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
            NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
        ]
        let attributedString = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)!
        
        return attributedString.string
    }
    
    func contains(find: String) -> Bool {
        return self.rangeOfString(find) != nil
    }
    
    func stringByDecodingHTMLEscapeCharacters() -> String? {
        var decodedString:String? = ""
        
        // Convert paragraph to newline
        var htmlString = self.stringByReplacingOccurrencesOfString("</p>", withString: "\n\n", options: .CaseInsensitiveSearch)
        
        // Remove all HTML tags
        htmlString = htmlString.stringByReplacingOccurrencesOfString("</a>", withString: " ", options: .CaseInsensitiveSearch)
        while let range = htmlString.rangeOfString("<[^>]+>", options: .RegularExpressionSearch) {
            htmlString = htmlString.stringByReplacingCharactersInRange(range, withString: "")
        }

        // Remove redundant newline characters
        var regex = NSRegularExpression(pattern: "(\n){3,}", options: nil, error: nil)
        decodedString = regex?.stringByReplacingMatchesInString(htmlString, options: nil, range: NSMakeRange(0, count(htmlString)), withTemplate: "\n\n")

        // Remove all percentage escapes
        if let escapedString = decodedString?.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            decodedString = escapedString
        }
        
        // Decode character entities (e.g. &amp;)
        for (encodedEntity, decodedEntity) in characterEntities {
            decodedString = decodedString?.stringByReplacingOccurrencesOfString(encodedEntity, withString: decodedEntity)
        }
        
        return decodedString
    }
    
    func stringByFormattingHTMLString(#imageCompletionHandler: (range: NSRange, string: NSAttributedString) -> Void) -> NSAttributedString {
        
        // Remove the first image as it is displayed in the header view
        var htmlString = removeFirstImageFromHTML()
        
        // Convert paragraph to newline
        htmlString = htmlString.stringByReplacingOccurrencesOfString("</p>", withString: "\n\n", options: .CaseInsensitiveSearch)
        htmlString = htmlString.stringByReplacingOccurrencesOfString("<p>", withString: "", options: .CaseInsensitiveSearch)
        
        // Convert <li> tag to "- "
        htmlString = htmlString.stringByReplacingOccurrencesOfString("<li>", withString: "\u{2022} ", options: .CaseInsensitiveSearch)
        
        // Use our own font for rendering the web page
        let textFont = [NSFontAttributeName: UIFont(name: "Lato-Regular", size: 18.0)!]
        let boldFont = [NSFontAttributeName: UIFont(name: "Lato-Bold", size: 18.0)!]

        // Strip off all HTML tags except H1, H2, H3, A, IMG and STRONG
        while let range = htmlString.rangeOfString("<(?!strong|/strong|h1|/h1|h2|/h2|h3|/h3|a|/a|img|/img)[^>]+>", options: .RegularExpressionSearch) {
            htmlString = htmlString.stringByReplacingCharactersInRange(range, withString: "")
        }
        
        // Remove image tags that are smaller than 100 points
        while let range = htmlString.rangeOfString("<img[^>]*(?:height|width)\\s*=\\s*['|\"][1-9]?[0-9]['|\"][^>]*>|<img[^>]*(feedsportal|feedburner)[^>]*>", options: .RegularExpressionSearch) {
            htmlString = htmlString.stringByReplacingCharactersInRange(range, withString: "")
        }
        
        // Decode escape characters
        if let decodedString = htmlString.stringByReplacingPercentEscapesUsingEncoding(NSUTF8StringEncoding) {
            htmlString = decodedString
        }
        
        // Decode character entities (e.g. &amp;)
        for (encodedEntity, decodedEntity) in characterEntities {
            htmlString = htmlString.stringByReplacingOccurrencesOfString(encodedEntity, withString: decodedEntity)
        }
        
        var attributedHTMLString = NSMutableAttributedString(string: htmlString, attributes: textFont)

        // Format the H1, H2, H3 and STRONG tags
        // Backup regex: (<strong.*>(.*?)</strong>|<h[1234].?>(?:<strong>){0,1}(.*?)(?:</strong>){0,1}</h[1234]>)
        if let boldTextRegEx = NSRegularExpression(pattern: "(<strong.*>(.*?)</strong>|<h[1234][^>]*>(?:<strong>){0,1}(.*?)(?:</strong>){0,1}</h[1234]>)", options: .CaseInsensitive, error: nil) {
            let results = boldTextRegEx.matchesInString(htmlString, options: nil, range: NSMakeRange(0, count(htmlString)))
            
            for match in results {
                let matchedString = (htmlString as NSString).substringWithRange(match.range)
                if match.numberOfRanges > 1 {
                    for var index = 2; index < match.numberOfRanges; index++ {
                        if match.rangeAtIndex(index).length != 0 {
                            let boldString = (htmlString as NSString).substringWithRange(match.rangeAtIndex(index)) as String
                            attributedHTMLString.addAttributes(boldFont, range: match.rangeAtIndex(index))
                        }
                    }
                }
            }
        }
        
        // Extract link
        if let linkRegEx = NSRegularExpression(pattern: "<a\\s+(?:[^>]*?\\s+)?href=\"([^\"]*)\"[^>]*>([^<]+)</a>", options: .CaseInsensitive, error: nil) {
            let results = linkRegEx.matchesInString(htmlString, options: nil, range: NSMakeRange(0, count(htmlString)))
            for match in results {
                if match.numberOfRanges == 3 {
                    let link = (htmlString as NSString).substringWithRange(match.rangeAtIndex(1)) as String
                    let linkTitle = (htmlString as NSString).substringWithRange(match.rangeAtIndex(2)) as String
                    attributedHTMLString.addAttribute(NSLinkAttributeName, value: link, range: match.rangeAtIndex(2))
                }
            }
        }
        
        // Extract the image source and download the image
        if let imgRegEx = NSRegularExpression(pattern: "<img.+?src=[\"'](.+?)[\"'].*?>", options: .CaseInsensitive, error: nil) {
            let results = imgRegEx.matchesInString(htmlString, options: nil, range: NSMakeRange(0, count(htmlString)))

            for (index, match) in enumerate(results) {
                var imageSource = (htmlString as NSString).substringWithRange(match.rangeAtIndex(1)) as String
                
                // See if we can get the image from the cache
                let imageCache = CacheManager.sharedCacheManager().cache
                if let cachedImage = imageCache.objectForKey(imageSource) as? UIImage {
                    println("Get image from cache: \(imageSource)")

                    let imageAttachment = ImageAttachment()
                    imageAttachment.image = cachedImage
                    imageAttachment.imageURL = imageSource
                    var attrStringWithImage = NSAttributedString(attachment: imageAttachment)
                    attributedHTMLString.insertAttributedString(attrStringWithImage, atIndex: match.rangeAtIndex(0).location + index)
                
                } else {

                    // Some URLs are encoded with "&amp;". Need to replace it with the actual "&"
                    imageSource = imageSource.stringByReplacingOccurrencesOfString("&amp;", withString: "&")

                    // Otherwise, we download the image from the source
                    if let imageURL = NSURL(string: imageSource.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!) {
                        let imageAttachment = ImageAttachment()
                        imageAttachment.image = UIImage()
                        imageAttachment.imageURL = imageURL.absoluteString!
                        var attrStringWithImage = NSAttributedString(attachment: imageAttachment)
                        attributedHTMLString.insertAttributedString(attrStringWithImage, atIndex: match.rangeAtIndex(0).location + index)
                        
                        NSURLSession.sharedSession().dataTaskWithURL(imageURL, completionHandler: { (data, response, error) -> Void in
                            
                            if error == nil {
                                if let image = UIImage(data: data) {
                                    imageAttachment.image = image
                                    println("Caching image: \(imageSource)")
                                    imageCache.setObject(image, forKey: imageSource)
                                    
                                    attributedHTMLString.enumerateAttribute(NSAttachmentAttributeName, inRange: NSMakeRange(0, attributedHTMLString.length), options: nil, usingBlock: {(value, range, stop) -> Void in
                                        
                                        if let attachment = value as? ImageAttachment {
                                            if attachment.imageURL == imageURL.absoluteString! {
                                                let newAttachmentString = NSAttributedString(attachment: attachment)
                                                imageCompletionHandler(range: range, string: newAttachmentString)
                                            }
                                        }
                                    })
                                }

                            } else {
                                println("Failed to download image: \(error.localizedDescription)")
                            }

                        }).resume()
                    }
                }
            }
        }

        // Remove the rest of HTML tags
        attributedHTMLString.replaceAllStrings("</(h1|h2|h3)>", replacement: "\n")
        attributedHTMLString.removeHTMLTags()
        attributedHTMLString.replaceAllStrings("^\\s+|\\s+$", replacement: "")
        
        // Remove redundant newline characters
        attributedHTMLString.replaceAllStrings("(\n){3,}", replacement: "\n\n")
        
        return attributedHTMLString
    }
    
    func parseFirstImage() -> String? {
        
        // Check if the given string contains an image
        // If it's not found, we just return an empty string
        if self.rangeOfString("<img", options: .CaseInsensitiveSearch) == nil {
            return ""
        }
        
        // Parse the given string and look for the first image
        let htmlScanner = NSScanner(string: self)
        var imageSrc: NSString?
        var firstImage:String? = ""
        
        htmlScanner.caseSensitive = false
        htmlScanner.scanUpToString("<img", intoString: nil)
        
        if htmlScanner.scanLocation < count(self) {
            htmlScanner.scanUpToString("src=", intoString: nil)
            htmlScanner.scanLocation += 5
            if htmlScanner.scanLocation < count(self) {
                let index = advance(self.startIndex, htmlScanner.scanLocation - 1)
                htmlScanner.scanUpToString("\(self[index])", intoString: &imageSrc)
                if (imageSrc?.rangeOfString("http://").location != NSNotFound ||
                    imageSrc?.rangeOfString("https://").location != NSNotFound) &&
                    imageSrc?.length > 7 {
                        firstImage = imageSrc! as String
                }
            }
        }
        
        // Return the URL of the image
        return firstImage
    }
    
    
    func removeFirstImageFromHTML() -> String {
        
        let htmlScanner = NSScanner(string: self)
        var htmlString = self
        
        if let imageTagRegEx = NSRegularExpression(pattern: "<img[^>]+>", options: .CaseInsensitive, error: nil) {
            var result = imageTagRegEx.firstMatchInString(self, options: nil, range: NSMakeRange(0, count(self)))
            
            if let range = result?.range {
                htmlString = (htmlString as NSString).stringByReplacingCharactersInRange(range, withString: "")
            }
        }
        
        return htmlString
    }

}