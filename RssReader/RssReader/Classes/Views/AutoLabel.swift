//
//  AutoLabel.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//rt UIKit

class AutoLabel: UILabel {

    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    override func layoutSubviews() {
        self.preferredMaxLayoutWidth = self.frame.size.width
    }
}
