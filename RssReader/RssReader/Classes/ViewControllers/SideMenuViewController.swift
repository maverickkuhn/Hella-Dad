//
//  SideMenuViewController.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    @IBOutlet weak var menuTitleLabel:UILabel!
    
    var currentFeed : (title: String, url: String)?
    var oldFeed: (title: String, url: String)?
    
    lazy var detailViewController: FeedsViewController = {
        var navigationFrontVC: UINavigationController?
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            navigationFrontVC = self.revealViewController().frontViewController as? UINavigationController
        } else {
            navigationFrontVC = self.splitViewController?.viewControllers.last as? UINavigationController;
        }
        let feedsVc = navigationFrontVC?.viewControllers.first as? FeedsViewController
        return feedsVc!
    }()
    
    var feedsURLs: [[String: String]] = ConfigurationManager.sharedConfigurationManager().feeds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        
        // Customize sidebar menu color
//        tableView.backgroundColor = UIColor(red: 39.0/255.0, green: 44.0/255.0, blue: 48.0/255.0, alpha: 1.0)
        
        if ConfigurationManager.defaultTheme().lowercaseString == "light" {
            tableView.backgroundColor = UIColor.clearColor()
            tableView.backgroundView = UIImageView(image: UIImage(named: "nav_bg"))
            var blurEffect = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            var blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            tableView.backgroundView?.addSubview(blurEffectView)
            tableView.separatorColor = UIColor.clearColor()
            
        } else if ConfigurationManager.defaultTheme().lowercaseString == "dark" {
            tableView.backgroundColor = UIColor(red: 39.0/255.0, green: 44.0/255.0, blue: 48.0/255.0, alpha: 1.0)
            tableView.separatorColor = UIColor(white: 0.15, alpha: 0.2)
        }
        
//        tableView.separatorColor = UIColor(white: 0.15, alpha: 0.2)
//        tableView.separatorColor = UIColor.clearColor()

        if menuTitleLabel != nil {
            menuTitleLabel.font = UIFont(name: ConfigurationManager.defaultBarFont(), size: 20.0)
        }
        
        currentFeed = self.detailViewController.currentFeeds
    }
    
    override func viewDidAppear(animated: Bool) {
        if currentFeed == nil {
            currentFeed = self.detailViewController.currentFeeds
            tableView.reloadData()
        }

        // Hide dropdown menu for iPad (landscape)
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.detailViewController.navigationHeaderButton.hidden = true
        }
    }
    
    override func viewDidDisappear(animated: Bool) {
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            self.detailViewController.navigationHeaderButton.hidden = false
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let currentTitle = feedsURLs[indexPath.row]["name"]
        let currentUrl = feedsURLs[indexPath.row]["url"]
        
        oldFeed = currentFeed
        currentFeed = (title: currentTitle!, url: currentUrl!)
        self.detailViewController.currentFeeds = currentFeed
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone {
            revealViewController().revealToggleAnimated(true)
        }
        
        // Reload table data to change the selected item
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return feedsURLs.count
    }
    
    private let cellReuseIdentifier = "cell"
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier) as? UITableViewCell

        cell?.textLabel?.text = feedsURLs[indexPath.row]["name"]
        cell?.textLabel?.font = UIFont(name: ConfigurationManager.defaultBarFont(), size: 16.0)
        cell?.imageView?.image = UIImage(named: "nav_radio")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        // Highlight the selected category
        if ConfigurationManager.defaultTheme() == "dark" {
            cell?.imageView?.tintColor = (cell?.textLabel?.text == currentFeed?.title) ? UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1.0) : UIColor(white: 0.8, alpha: 0.9)
            cell?.textLabel?.textColor = (cell?.textLabel?.text == currentFeed?.title) ? UIColor(red: 0.0/255.0, green: 174.0/255.0, blue: 239.0/255.0, alpha: 1.0) : UIColor(white: 0.8, alpha: 0.9)
        } else if ConfigurationManager.defaultTheme() == "light" {
            cell?.imageView?.tintColor = (cell?.textLabel?.text == currentFeed?.title) ? UIColor(red: 166.0/255.0, green: 37.0/255.0, blue: 15.0/255.0, alpha: 1.0) : UIColor.grayColor()
            cell?.textLabel?.textColor = (cell?.textLabel?.text == currentFeed?.title) ? UIColor(red: 166.0/255.0, green: 37.0/255.0, blue: 15.0/255.0, alpha: 1.0) : UIColor.grayColor()
        }

        // Transparent background
        cell?.backgroundColor = UIColor.clearColor()
        
        return cell!
    }
    
}
