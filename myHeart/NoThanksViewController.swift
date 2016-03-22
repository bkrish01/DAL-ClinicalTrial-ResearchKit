//
//  NoThanksViewController.swift
//  myHeart
//
//  Created by Krishnapillai, Bala on 2/28/16.
//  Copyright © 2016 Bala Krishnapillai. All rights reserved.
//
import Foundation
import UIKit
import Social
import MessageUI
class NoThanksViewController: UIViewController , MFMailComposeViewControllerDelegate {

    @IBOutlet weak var contactDal: UIBarButtonItem?
    @IBOutlet weak var showInfo: UIBarButtonItem?
    @IBOutlet weak var launchAppStore: UIBarButtonItem?
    @IBOutlet weak var sendEmail: UIBarButtonItem?
    var mailEvent: String = ""

    @IBAction func sendEmailToDal(sender: AnyObject) {
        mailEvent = "Contact DAL"
        showMailComposer("dal_contact@amgen.com")
    }
    @IBAction func facebookshare(sender: AnyObject) {
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook) {
            var fbShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            
            self.presentViewController(fbShare, animated: true, completion: nil)
            
        } else {
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Facebook account to share.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
//    @IBAction func sendMessage(sender: AnyObject) {
//        var messageVC = MFMessageComposeViewController()
//        
//        messageVC.body = "Enter a message";
//        messageVC.recipients = ["Enter tel-nr"]
//        messageVC.messageComposeDelegate = self;
//        
//        self.presentViewController(messageVC, animated: false, completion: nil)
//    }
    

//    @IBAction func sendMessage(sender: AnyObject) {
//        var messageVC = MFMessageComposeViewController()
//        messageVC.body = "Enter a message";
//        messageVC.recipients = ["Enter tel-nr"]
//        messageVC.messageComposeDelegate = self;
//        self.presentViewController(messageVC, animated: false, completion: nil)
//    }
    @IBAction func sharewithTwitter(sender: AnyObject) {
        
        if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter) {
            
            var tweetShare:SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            
            self.presentViewController(tweetShare, animated: true, completion: nil)
            
        } else {
            
            var alert = UIAlertController(title: "Accounts", message: "Please login to a Twitter account to tweet.", preferredStyle: UIAlertControllerStyle.Alert)
            
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func NoThanksAction(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let secondView = self.storyboard!.instantiateViewControllerWithIdentifier("Homemain") as! UIViewController
        self.presentViewController(secondView, animated: true, completion: nil)

        //self.dismissViewControllerAnimated(true, completion: nil)
        //self.presentViewController((storyboard?.instantiateInitialViewController())!,animated:true, completion: nil)
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
//    func messageComposeViewController(controller: MFMessageComposeViewController!, didFinishWithResult result: MessageComposeResult) {
//        switch (result.value) {
//        case MessageComposeResultCancelled.value:
//            print("Message was cancelled")
//            self.dismissViewControllerAnimated(true, completion: nil)
//        case MessageComposeResultFailed.value:
//            print("Message failed")
//            self.dismissViewControllerAnimated(true, completion: nil)
//        case MessageComposeResultSent.value:
//            print("Message was sent")
//            self.dismissViewControllerAnimated(true, completion: nil)
//        default:
//            break;
//        }
//    }
   
    
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
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Shows the information about the app on first launch and also on tapping the tool bar button
    
        func showMailComposer(recipient: String){
        if(MFMailComposeViewController.canSendMail())
        {
            var subject : String = ""
            var body : String = ""
            var appUrl : String = ""
            var message : String = ""
            
                subject = "Cool App" as! String
                body = "Check out Amgen's Share your Journey, a research study app about Migraine. Download it for iPhone at dal.cloudmine.com" as! String
                appUrl = "http://dalstore.cloudmineapp.com" as! String
                message = String(format: body, "\n", appUrl)

            let toRecipients = [recipient]
            
            let mailComposer : MFMailComposeViewController = MFMailComposeViewController()
            
            mailComposer.mailComposeDelegate = self
            mailComposer.setSubject(subject)
            mailComposer.setMessageBody(message, isHTML: false)
            mailComposer.setToRecipients(toRecipients)
            
            self.presentViewController(mailComposer, animated:true, completion: nil)
        }
    }
    

}
