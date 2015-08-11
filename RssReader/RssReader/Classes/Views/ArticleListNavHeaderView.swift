//
//  ArticleListNavHeader.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

class ArticleListNavHeaderView: UIView {
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var menuButton:UIButton!

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
            self.titleLabel.font = UIFont(name: ConfigurationManager.defaultCellFont(), size: 19.0)
        }
    }
}
