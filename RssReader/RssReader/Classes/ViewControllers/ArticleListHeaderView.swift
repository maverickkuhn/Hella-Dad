//
//  ArticleListHeaderView.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

class ArticleListHeaderView: ArticleHeaderView {
    @IBOutlet weak var columnLabel:UILabel!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var authorLabel:UILabel!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func awakeFromNib() {
        configure()
    }
    
    func configure() -> Void {
        if ConfigurationManager.defaultCellFont() != "default" {
            titleLabel.font = UIFont(name: ConfigurationManager.defaultCellFont(), size: 31.0)
            columnLabel.font = UIFont(name: ConfigurationManager.defaultCellFont(), size: 10.0)
            authorLabel.font = UIFont(name: ConfigurationManager.defaultCellFont(), size: 10.0)
        }
    }

}
