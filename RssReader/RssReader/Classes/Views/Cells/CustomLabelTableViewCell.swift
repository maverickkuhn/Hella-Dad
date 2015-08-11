//
//  CustomLabelTableViewCell.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//


import UIKit

class CustomLabelTableViewCell: UITableViewCell {
    @IBOutlet weak var label:UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configure() -> Void {
        if ConfigurationManager.defaultCellFont() != "default" {
            label.font = UIFont(name: ConfigurationManager.defaultCellFont(), size: 31.0)
        }
    }

}
