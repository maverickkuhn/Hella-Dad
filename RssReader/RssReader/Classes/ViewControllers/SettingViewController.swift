//
//  SettingViewController.swift
//  RssReader
//
//  Created by HellaDad on 07/20/15.
//  Copyright (c) 2015 HellaDad. All rights reserved.
//
import UIKit
import MessageUI

class SettingViewController: UITableViewController, MFMailComposeViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func Store(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(NSURL(string: "https://www.helladad.com/shop/")!)
        
        
    }
    func sendUsFeedback() {
        if MFMailComposeViewController.canSendMail() {
            var composer = MFMailComposeViewController()
            
            composer.mailComposeDelegate = self

            // Uncomment if you need to set a default email
            composer.setToRecipients(["<jackson@helladad.com>"])
            composer.navigationBar.tintColor = UIColor.whiteColor()
            
            presentViewController(composer, animated: true, completion: {
                switch ConfigurationManager.defaultTheme() {
                    case "dark":
                        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
                    case "light":
                        UIApplication.sharedApplication().setStatusBarStyle(.Default, animated: false)
                    default:
                        break
                }
                
            })
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
        case MFMailComposeResultCancelled.value:
            println("Mail cancelled")
            
        case MFMailComposeResultSaved.value:
            println("Mail saved")
            
        case MFMailComposeResultSent.value:
            println("Mail sent")
            
        case MFMailComposeResultFailed.value:
            println("Failed to send mail: \(error.localizedDescription)")
            
        default:
            break
        }
        
        // Dismiss the Mail interface
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func dismissController() {
        // Dismiss the current interface
        dismissViewControllerAnimated(true, completion: nil)

    }
    
    // MARK: - Table view data source

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            sendUsFeedback()
        }
    }
    

}
