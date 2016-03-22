//
//  HomePageViewController.swift
//  myHeart
//
//  Created by Bala Krishnapillai on 02/24/16.
//  Copyright © 2016 Bala Krishnapillai. All rights reserved.
//

import UIKit
import ResearchKit
import MessageUI

class HomePageViewController: UIViewController {

    let healthManager:HealthKit = HealthKit()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func lauchTaskController()
    {
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let secondView = storyboard.instantiateViewControllerWithIdentifier("TasksandResultsView") as! UITabBarController
        //let secondView = storyboard.instantiateViewControllerWithIdentifier("EligibilityView") as! UINavigationController
        self.presentViewController(secondView, animated: true, completion: nil)
    }
    
    @IBAction func startConsent(sender: AnyObject) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("UserId") != nil
        {
            lauchTaskController()
        }
        else
        {
            // authorizes health Kit
            healthManager.authorizeHealthKit{(authorized,error) -> Void in
                //presents the consent task if authorized
                if authorized {
                    let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
                    taskViewController.delegate = self
                    self.presentViewController(taskViewController, animated: true, completion: nil)
                }
                else {
                    if error != nil {
                        print("\(error)")
                    }
                }
            }
        }
        
    }
    
    
    @IBAction func ThanksAction(sender: AnyObject) {
//        self.dismissViewControllerAnimated(true, completion: nil)
//        self.presentViewController((storyboard?.instantiateInitialViewController())!,animated:true, completion: nil)
    }
    
    
    
    @IBAction func startStudy(sender: UIButton) {
        
        if NSUserDefaults.standardUserDefaults().objectForKey("UserId") != nil
        {
            // lauchTaskController()
            let storyboard = UIStoryboard(name: "Main", bundle:nil)
            //let secondView = storyboard.instantiateViewControllerWithIdentifier("TasksandResultsView") as! UITabBarController
            let secondView = storyboard.instantiateViewControllerWithIdentifier("EligibilityView") as! UINavigationController
            self.presentViewController(secondView, animated: true, completion: nil)
        }
        else
        {
        // authorizes health Kit
        healthManager.authorizeHealthKit{(authorized,error) -> Void in
            //presents the consent task if authorized
            if authorized {
                /*let taskViewController = ORKTaskViewController(task: ConsentTask, taskRunUUID: nil)
                    taskViewController.delegate = self
                    self.presentViewController(taskViewController, animated: true, completion: nil)
                */
                let storyboard = UIStoryboard(name: "Main", bundle:nil)
                let secondView = self.storyboard!.instantiateViewControllerWithIdentifier("EligibilityView") as! UINavigationController
                self.presentViewController(secondView, animated: true, completion: nil)
                
            }
            else {
                if error != nil {
                    print("\(error)")
                }
            }
        }
        }
        
    }
    
}
extension HomePageViewController: ORKTaskViewControllerDelegate, MFMailComposeViewControllerDelegate {
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        
        switch reason {
        case .Completed:
            
            if let signatureResult = taskViewController.result.stepResultForStepIdentifier("ConsentReviewStep")?.firstResult as? ORKConsentSignatureResult {
                //applies the signature
                let userInfoDic = NSMutableDictionary()
                userInfoDic.setValue(signatureResult.signature?.givenName, forKey: "firstName")
                userInfoDic.setValue(signatureResult.signature?.familyName, forKey: "lastName")
                createUser(userInfoDic)
            }
           
            //Grabs the information from the consent review step
            let crstep = taskViewController.task?.stepWithIdentifier!("ConsentReviewStep") as! ORKConsentReviewStep
            
            //Generates a document
            let document = crstep.consentDocument
            if let signatureResult = taskViewController.result.stepResultForStepIdentifier("ConsentReviewStep")?.firstResult as? ORKConsentSignatureResult {
                //applies the signature
                signatureResult.applyToDocument(document)
            }
            
            var fileData  = NSData()
            //creates a pdf
            document .makePDFWithCompletionHandler({ (NSData pdfFile, NSError error) -> Void in
                
                //let signature = document.signatures!.first
                let documentsPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] + "Consent.pdf"
                //writes to the pdf
                pdfFile!.writeToFile(documentsPath, atomically: false)
                fileData = pdfFile!
                
                //if an email account is set up on phone
                if(MFMailComposeViewController.canSendMail())
                {
                    let emailTitle = "Signed Consent Form"
                    let messageBody = "Dear Participant, \n Please find enclosed the signed consent form."
                    let toRecipients = ["bthulasi@amgen.com"]
                    
                    let mc:MFMailComposeViewController = MFMailComposeViewController()
                    
                    mc.mailComposeDelegate = self
                    mc.setSubject(emailTitle)
                    mc.setMessageBody(messageBody, isHTML: false)
                    //let documentsPath = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
                    //let pdfFileName = documentsPath + "Consent.pdf"
                    //let documentsPath = NSBundle.mainBundle().pathForResource("Consent", ofType: "pdf")
                    //setting up the email attachment
                    //var fileData = pdfFileName.dataUsingEncoding(NSUTF8StringEncoding) //fileData = NSData(contentsOfFile: pdfFileName)
                    
                    mc.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "Consent")
                    
                    mc.setToRecipients(toRecipients)
                    
                    //dismiss current view controller and present the mail controller
                    taskViewController.dismissViewControllerAnimated(true, completion: nil)
                    self.presentViewController(mc,animated:true, completion: nil)
                }

            })
            
            
        case .Saved:
            
            taskViewController.dismissViewControllerAnimated(true, completion: nil)

        case .Failed, .Discarded:
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
            self.presentViewController((storyboard?.instantiateInitialViewController())!,animated:true, completion: nil)
           
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result:MFMailComposeResult, error:NSError?)
    {
        switch result.rawValue {
        case MFMailComposeResultCancelled.rawValue:
            print("mail cancelled")
        case MFMailComposeResultSaved.rawValue:
            print("Mail Saved")
        case MFMailComposeResultSent.rawValue:
            print("Mail Sent")
        case MFMailComposeResultFailed.rawValue:
            print("Mail Failed")
        default:
            break
        }
        
        //once email sent go to main window with tasks and graphs
        let storyboard = UIStoryboard(name: "Main", bundle:nil)
        let secondView = storyboard.instantiateViewControllerWithIdentifier("TasksandResultsView") as! UITabBarController
        controller.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController(secondView, animated: true, completion: nil)
    }

    
    func createUser(userNameDictionary : NSDictionary)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: "https://api.cloudmine.me/v1/app/28885ce6bcf84894a485a67835eba1fa/run/createMCTUser?apikey=0a1b4806f62c41789856025175e70fe5")!)
        let session = NSURLSession.sharedSession()
        request.HTTPMethod = "POST"
        
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(userNameDictionary, options: NSJSONWritingOptions.PrettyPrinted)
            print("JSON Data = \(jsonData)")
            
            print("JSON String \(String(data: jsonData, encoding: NSUTF8StringEncoding))")
            request.HTTPBody = jsonData
            
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                print("Response: \(response)")
                //print("Response String \(String(data: data!, encoding: NSUTF8StringEncoding))")
                self.parseResponse(data!)
                dispatch_async(dispatch_get_main_queue(),{
                //self.dismissAndPresentTaskVC()
                })
                
            })
            
            task.resume()
            
        } catch let error as NSError {
            //dismissAndPresentTaskVC()
            print(error)
        }
    }
    
    func parseResponse(responseData : NSData)
    {
        do {
            let jsonDictionary = try NSJSONSerialization.JSONObjectWithData(responseData, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
            // use anyObj here
            print("jsonDictionary\(jsonDictionary)")
            let userId = jsonDictionary.objectForKey("result")?.objectForKey("data")?.objectForKey("uId")
            print(userId)
            
            NSUserDefaults.standardUserDefaults().setValue(userId, forKey: "UserId")
        } catch let error as NSError {
            print("json error: \(error.localizedDescription)")
        }
    }
    
    func dismissAndPresentTaskVC()
    {
        self.dismissViewControllerAnimated(true, completion: {
            //once email sent go to main window with tasks and graphs
            self.lauchTaskController()
        })
    }
}

