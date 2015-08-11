//
//  ArticleExcerptViewController.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//

import UIKit

class ArticleExcerptViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextViewDelegate {
    @IBOutlet weak var tableView:UITableView!
    @IBOutlet weak var headerView:ArticleHeaderView!

    var article: Article?
    
    // Header view configuration
    private var defaultTableHeaderHeight:CGFloat = 250.0
    private var lastContentOffset:CGFloat = 0.0
    private let defaultHeaderImageName = "bg-pattern"
  
    // Transition animator for 
    var transitionAnimator:SlideUpTransitionAnimator = SlideUpTransitionAnimator()
    
    private var tappedLink:String = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.separatorStyle = .None
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Add the header view to the table view background
        defaultTableHeaderHeight = headerView.frame.size.height
        lastContentOffset = -defaultTableHeaderHeight
        
        tableView.tableHeaderView = nil
        tableView.addSubview(headerView)
        tableView.sendSubviewToBack(headerView)
        
        tableView.contentInset = UIEdgeInsets(top: defaultTableHeaderHeight, left: 0, bottom: 0, right: 0)
        tableView.contentOffset = CGPoint(x: 0, y: -defaultTableHeaderHeight)

        if let articleImageURL = article?.headerImageURL {
            if articleImageURL != "" {
                // Download the article image
                headerView.imageView.sd_setImageWithURL(NSURL(string: articleImageURL), completed: { (image, error, SDImageCacheType, url) -> Void in
                    if image != nil {
                        self.headerView.imageView.image = image
                    } else {
                        
                        self.headerView.imageView.image = UIImage(named: self.defaultHeaderImageName)
                    }
                    
                })
            } else {
                headerView.imageView.image = UIImage(named: defaultHeaderImageName)
            }
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        updateHeaderView()
    }
    
    func updateHeaderView() {
        var headerViewFrame = CGRect(x: 0, y: -defaultTableHeaderHeight, width: tableView.bounds.size.width, height: defaultTableHeaderHeight)
        headerView.frame = headerViewFrame
    }
    
    // MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        var headerViewFrame = CGRect(x: 0, y: -defaultTableHeaderHeight, width: tableView.bounds.size.width, height: defaultTableHeaderHeight)
        
        // Keep the view origin to the top and scale the height of the frame
        // to create a stretchy effect
        //        if offsetY < -defaultTableHeaderHeight {
        if offsetY < 0 {
            headerViewFrame.origin.y = offsetY
            headerViewFrame.size.height =  -offsetY
        }
        
        headerView.frame = headerViewFrame
        
        // Hide the status bar when scrolling up
        if offsetY + defaultTableHeaderHeight > 10 {
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation:
                .Fade)
        } else {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation:
                .Fade)
        }
  /*
        if -offsetY >= defaultTableHeaderHeight || lastContentOffset > offsetY {
            // Scroll down
            navHeaderView.closeButton.alpha = 0.5
        } else if lastContentOffset < offsetY {
            // Scroll up
            UIView.animateWithDuration(0.2, delay: 0.0, options: nil, animations: {
                self.navHeaderView.closeButton.alpha = 0.0
                }, completion: nil)
        }

        lastContentOffset = offsetY */
    }
    
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        coordinator.animateAlongsideTransition({ (context) -> Void in
            self.updateHeaderView()
            }, completion: {(context) -> Void in
        })
        
        
    }
    
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let headerCell = tableView.dequeueReusableCellWithIdentifier("HeaderCell", forIndexPath: indexPath) as! ArticleMetaViewCell
            headerCell.titleLabel.text = article?.title
            if let authorName = article?.authorName {
                headerCell.authorLabel.text = (authorName == "") ? "" : "BY \(authorName)".uppercaseString
            }
            
            return headerCell
            
        } else if indexPath.section == 1 {
            let contentCell = tableView.dequeueReusableCellWithIdentifier("ContentCell", forIndexPath: indexPath) as! ArticleTextLabelViewCell
            
            contentCell.descriptionTextView.delegate = self
            contentCell.descriptionTextView.attributedText = NSAttributedString(string: "")
            
            var articleDescription:String?
            if article?.content != "" {
                articleDescription = article?.content
            } else {
                articleDescription = article?.rawDescription
            }

            // The article description is originally in HTML format. Here we call up
            // the stringByFormattingHTMLString() to generate the attributed string.
            var textDescription = articleDescription?.stringByFormattingHTMLString(imageCompletionHandler: { (range, string) -> Void in

                NSOperationQueue.mainQueue().addOperationWithBlock({

                    // Once the image is downloaded, replace the image with the empty image
                    // generated by default
                    contentCell.descriptionTextView.textStorage.replaceCharactersInRange(range, withAttributedString: string)
                    
                    // Ask the table view cell to update its size
                    let currentSize = contentCell.descriptionTextView.bounds.size
                    let newSize = contentCell.descriptionTextView.sizeThatFits(CGSize(width: currentSize.width, height: CGFloat.max))
                    
                    if newSize.height != currentSize.height {
                        self.tableView.beginUpdates()
                        self.tableView.endUpdates()
                    }

                })

            })

            contentCell.descriptionTextView.attributedText = textDescription
            
            return contentCell
        }
        
        return UITableViewCell()
    }
    
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var cellHeight:CGFloat = 44.0
        
        if indexPath.section == 0 {
            cellHeight = 70.0
            
        } else if indexPath.section == 1 {
            cellHeight = 281.0
        }
        
        return cellHeight
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showArticle" {
            let destinationViewController:DetailArticleViewController
            destinationViewController = segue.destinationViewController as! DetailArticleViewController
            destinationViewController.article = article // selectedArticle

            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
            destinationViewController.transitioningDelegate = transitionAnimator
        
        } else if segue.identifier == "showLink" {
            let destinationViewController:DetailArticleViewController
            destinationViewController = segue.destinationViewController as! DetailArticleViewController
            let articleToDisplay = Article()
            articleToDisplay.link = tappedLink
            destinationViewController.article = articleToDisplay // selectedArticle
            
            UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
            destinationViewController.transitioningDelegate = transitionAnimator
            
        }

    }
    
    @IBAction func unwindToExcerptScreen(segue: UIStoryboardSegue) {
        if UIApplication.sharedApplication().statusBarHidden {
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        }
    }
    
    // Action method for activating the share actions
    @IBAction func shareAction(sender: UIBarButtonItem) {
        
        var sharingItems = [AnyObject]()
        if let title = article?.title {
            if let link = article?.link {
                sharingItems.append(title)
                sharingItems.append(NSURL(string: link)!)
            } else {
                sharingItems.append(title)
            }
        }
        
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: [SafariActivity()])
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            activityViewController.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        }
        
        self.presentViewController(activityViewController, animated: true, completion: nil)
    }

    // MARK: - UITextViewDelegate
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        if let link = URL.absoluteString {
            tappedLink = link
            performSegueWithIdentifier("showLink", sender: self)
        }

        return false
    }
    
    
    func textViewDidChange(textView: UITextView) {
        let currentSize = textView.bounds.size
        let newSize = textView.sizeThatFits(CGSize(width: currentSize.width, height: CGFloat.max))
        
        if newSize.height != currentSize.height {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }

    
}
