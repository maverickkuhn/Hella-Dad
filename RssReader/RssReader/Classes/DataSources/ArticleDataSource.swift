//
//  ArticleDataSource.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

typealias ConfigureArticleCellClosure = (articleCell: ArticleViewCell, article: Article, indexPath: NSIndexPath) -> ()

class ArticleDataSource: NSObject, UITableViewDataSource {

    var articles = [Article]()
    
    var configureCellClosure: ConfigureArticleCellClosure!
    
    init(configureCellClosure: ConfigureArticleCellClosure!) {
        super.init()
        self.configureCellClosure = configureCellClosure
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }
    
    private let cellReuseIdentifier = "ArticleViewCell"
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as? UITableViewCell
        
        if cell == nil {
            cell = ArticleViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellReuseIdentifier)
        }
        
        let articleCell = cell as? ArticleViewCell;
        let article = articles[indexPath.row]
        
        self.configureCellClosure(articleCell: articleCell!, article: article, indexPath: indexPath)
        
        return cell!;
    }
    
    subscript(index: Int) -> Article {
        return articles[index]
    }
}