//
//  ViewController.swift
//  DAL_iOS_StarterKit
//
//  Created by Thulasingam, Bhakeeswaran on 2/9/16.
//  Copyright © 2016 Amgen. All rights reserved.
//

import UIKit
import MessageUI

class ViewController: UIViewController, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var contactDal: UIBarButtonItem?
    @IBOutlet weak var showInfo: UIBarButtonItem?
    @IBOutlet weak var launchAppStore: UIBarButtonItem?
    @IBOutlet weak var sendEmail: UIBarButtonItem?
    var mailEvent: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(animated: Bool) {
        if NSUserDefaults.standardUserDefaults().objectForKey("InitialLaunch") == nil
        {
            showAppInformation();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Action Events
    
    @IBAction func showInfoTapped(sender: AnyObject) {
        showAppInformation()
    }
    
    @IBAction func sendEmailToDal(sender: AnyObject) {
        mailEvent = "Contact DAL"
        showMailComposer(ConfigSettings.sharedInstance.DALEmail)
    }
    
    @IBAction func shareApp(sender: AnyObject) {
        mailEvent = "Share App"
        showMailComposer("")
    }
    
    // MARK: - MailComposeViewController delegate
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?)
    {
        var action: String = ""
        switch result.rawValue {
            case MFMailComposeResultCancelled.rawValue:
                action = "cancelled"
            case MFMailComposeResultSaved.rawValue:
                action = "saved"
            case MFMailComposeResultSent.rawValue:
                action = "sent"
            case MFMailComposeResultFailed.rawValue:
                action = "failed"
            default:
                break
        }
        
        //
        NewRelic.recordEvent(mailEvent, attributes: ["action": action])
        
        //
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Private Functions
    
    func setupUI(){
        navigationItem.title = ConfigSettings.sharedInstance.AppTitle
    }
    
    // Shows the information about the app on first launch and also on tapping the tool bar button
    func showAppInformation(){
        NewRelic.recordEvent("Show Info", attributes: ["action":"tapped"])
        let message : String = String(format: ConfigSettings.sharedInstance.AppInfoContent, "\n\n")
        let alertController = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: .Default) { (action:UIAlertAction!) in
            if NSUserDefaults.standardUserDefaults().objectForKey("InitialLaunch") == nil
            {
                // Register for user notification settings
                let settings = UIUserNotificationSettings(forTypes: [.Sound, .Alert, .Badge], categories: nil)
                UIApplication.sharedApplication().registerUserNotificationSettings(settings)
                
                // Register for remote notifications
                UIApplication.sharedApplication().registerForRemoteNotifications()
                
                // Record that the first launch is completed
                NSUserDefaults.standardUserDefaults().setValue("Done", forKey: "InitialLaunch")
            }
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    func showMailComposer(recipient: String){
        if(MFMailComposeViewController.canSendMail())
        {
            var subject : String = ""
            var body : String = ""
            var appUrl : String = ""
            var message : String = ""
            
            if(recipient.isEmpty){
                subject = ConfigSettings.sharedInstance.EmailSettings.valueForKey("Subject") as! String
                body = ConfigSettings.sharedInstance.EmailSettings.valueForKey("Body") as! String
                appUrl = ConfigSettings.sharedInstance.EmailSettings.valueForKey("AppURL") as! String
                message = String(format: body, "\n", appUrl)
            }
            let toRecipients = [recipient]
            
            let mailComposer : MFMailComposeViewController = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(message, isHTML: false)
            mailComposer.setToRecipients(toRecipients)
            
            self.presentViewController(mailComposer, animated:true, completion: nil)
        }
    }
    
    func customNewRelicInteractionName() -> NSString
    {
        return "Home View"
    }
}

