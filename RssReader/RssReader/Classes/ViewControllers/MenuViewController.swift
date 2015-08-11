//
//  MenuViewController.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

protocol MenuViewDelegate {
    func didSelectMenuItem(feed:[String: String])
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerView:UIView!
    
    let feedsURLs: [[String: String]] = ConfigurationManager.sharedConfigurationManager().feeds
    private var isMenuItemShown:[Bool]!
    
    var delegate:MenuViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the menu background based on the preferred theme
        switch ConfigurationManager.defaultTheme().lowercaseString {
        case "dark":
            tableView.backgroundColor = FlatColor.DarkOrange.color()
            headerView.backgroundColor = FlatColor.DarkOrange.color()
        case "light":
            tableView.backgroundColor = FlatColor.BrightYellow.color()
            headerView.backgroundColor = FlatColor.BrightYellow.color()
        default: break
        }
        
        isMenuItemShown = [Bool](count: self.feedsURLs.count, repeatedValue: false)
        
        // Hide status bar
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return feedsURLs.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! CustomLabelTableViewCell
        
        // Set the menu background based on the preferred theme
        switch ConfigurationManager.defaultTheme().lowercaseString {
        case "dark":
            cell.backgroundColor = FlatColor.DarkOrange.color()
        case "light":
            cell.backgroundColor = FlatColor.BrightYellow.color()
        default: break
        }

        // Set the feed name and font
        cell.label.text = feedsURLs[indexPath.row]["name"]
        
        return cell
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if isMenuItemShown[indexPath.row] {
            return
        }
        
        cell.alpha = 0.0
        cell.transform = CGAffineTransformMakeTranslation(0, 100)
        UIView.animateWithDuration(0.5, delay: 0.02 * Double(indexPath.row), options: nil, animations: {
            cell.transform = CGAffineTransformIdentity
            cell.alpha = 1.0
            }, completion: nil)
        isMenuItemShown[indexPath.row] = true
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let feed = feedsURLs[indexPath.row]
        delegate?.didSelectMenuItem(feed)
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        performSegueWithIdentifier("unwindToMainScreen", sender: self)
    }

    
}

