//
//  SecondTableViewController.swift
//  myResearchKit
//
//  Created by Shashank Kothapalli on 8/7/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import UIKit
import ResearchKit
import WebKit



var completed = false
class TasksTableViewController: UITableViewController, ORKTaskViewControllerDelegate {
    
   
    var selectedSurveyId : String = ""
    let sections = ["Survey", "Tasks"]
    let surveys = [["Migraine - Phase 1","Migraine - Phase 2"], ["Joint Movement"]]
    var tasks = [[SurveyTask,SurveyTask], [TwoFingerTappingTask]]
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return surveys.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return surveys[section].count
        
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "SurveyCell")
        cell.textLabel?.text = surveys[indexPath.section][indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let taskViewController = ORKTaskViewController(task: tasks[indexPath.section][indexPath.row], taskRunUUID: nil)
        taskViewController.delegate = self
        selectedSurveyId = surveys[indexPath.section][indexPath.row]
        presentViewController(taskViewController, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sections[section]
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, didUnhighlightRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        cell?.accessoryType = UITableViewCellAccessoryType.Checkmark
    }
    
    func taskViewController(taskViewController: ORKTaskViewController, didFinishWithReason reason: ORKTaskViewControllerFinishReason, error: NSError?) {
        
        switch reason {
        case .Completed:
            completed = true
            //
            parseResult(taskViewController)
            
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
        case .Saved, .Failed, .Discarded:
            taskViewController.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
func parseResult(taskViewController: ORKTaskViewController)
{
    let resultMutableArray = NSMutableArray()
    
    let taskResult = taskViewController.result // this should be a ORKTaskResult
    let results = taskResult.results as! [ORKStepResult]//[ORKStepResult]
    
    for thisStepResult in results { // [ORKStepResults]
        let stepResults = thisStepResult.results as! [ORKQuestionResult]
        for item in stepResults {
            if let answer = item as? ORKBooleanQuestionResult {
                if answer.booleanAnswer != nil {
                    print(answer.identifier)
                    if answer.booleanAnswer == true {
                        resultMutableArray.addObject("Yes")
                        print("Answer is Yes")
                    } else {
                        resultMutableArray.addObject("No")
                        print("Answer is No")
                    }
                }
            }
            else if let answer = item as? ORKChoiceQuestionResult
            {
                if answer.choiceAnswers != nil {
                    print(answer.identifier)
                    resultMutableArray.addObject(answer.choiceAnswers!.last!)
                    print(answer.choiceAnswers)
                }
            }
        }
    }
    convertIntoJSON(resultMutableArray)
}


func convertIntoJSON(answerArray: NSMutableArray)
{
    let questionMutableArray = NSMutableArray()
    questionMutableArray.addObject("Do you have Migraine now?")
    questionMutableArray.addObject("How long do you have this Migraine?")
    questionMutableArray.addObject("Which part of your head gives you more head ache?")
    questionMutableArray.addObject("How do you classify your Migrine?")
    
    let q2Answers : NSMutableDictionary = [ 0 : "Not now" ,  1 : "> 1 Hours", 2 : "> 2 Hours" , 4 : "> 4 Hours" , 8 : "> 8 Hours" , 24 : "> 24 Hours"]
    let q3Answers : NSMutableDictionary = [ 0 : "Left" , 1 : "Right" , 2 : "Front" ,3 :  "Back" , 4 : "Top" ,  5 : "All"]
    let q4Answers : NSMutableDictionary = [ 0 : "Throbbing" , 1 : "Pulzating", 2 : "Others"]
    
    let durationDictionary = NSMutableDictionary()
    durationDictionary.setValue("How long do you have this Migraine?", forKey: "questionText")
    durationDictionary.setValue(q2Answers.objectForKey(answerArray.objectAtIndex(1) as! Int), forKey: "answerText")
    durationDictionary.setValue((answerArray.objectAtIndex(1) as! Int), forKey: "answerValue")
    
    let severityDictionary = NSMutableDictionary()
    severityDictionary.setValue("Do you have Migraine now?", forKey: "questionText")
    severityDictionary.setValue(answerArray.objectAtIndex(0), forKey: "answerText")
    severityDictionary.setValue(answerArray.objectAtIndex(0) as! String == "Yes" ? "true" : "false", forKey: "answerValue")
    
    let locationDictionary = NSMutableDictionary()
    locationDictionary.setValue("Which part of your head gives you more head ache?", forKey: "questionText")
    locationDictionary.setValue(q3Answers.objectForKey(answerArray.objectAtIndex(2) as! Int), forKey: "answerText")
    locationDictionary.setValue((answerArray.objectAtIndex(2) as! Int), forKey: "answerValue")
    
    let classificationDictionary = NSMutableDictionary()
    classificationDictionary.setValue("How do you classify your Migrine?", forKey: "questionText")
    classificationDictionary.setValue(q4Answers.objectForKey(answerArray.objectAtIndex(2) as! Int), forKey: "answerText")
    classificationDictionary.setValue((answerArray.objectAtIndex(3) as! Int), forKey: "answerValue")
    
    let response = Response()
    response.duration = durationDictionary
    response.severity = severityDictionary
    response.location = locationDictionary
    response.classification = classificationDictionary
    
    let surveyResponseobject = SurveyResponse()
    surveyResponseobject.surveyId = selectedSurveyId
    surveyResponseobject.classification = classificationDictionary
    surveyResponseobject.duration = durationDictionary
    surveyResponseobject.severity = severityDictionary
    surveyResponseobject.location = locationDictionary
    //surveyResponseobject.response = response
    
    print(surveyResponseobject)
    
    do {
        let jsonData = try NSJSONSerialization.dataWithJSONObject(returnResponseDictionary(response, surveyResponse: surveyResponseobject), options: NSJSONWritingOptions.PrettyPrinted)
        print("JSON Data = \(jsonData)")
        
        print("JSON String \(String(data: jsonData, encoding: NSUTF8StringEncoding))")
        postResponse(jsonData)
    } catch let error as NSError {
        print(error)
    }
}

func postResponse(jsonData : NSData)
{
    let request = NSMutableURLRequest(URL: NSURL(string: "https://api.cloudmine.me/v1/app/28885ce6bcf84894a485a67835eba1fa/run/recordResponse?apikey=0a1b4806f62c41789856025175e70fe5")!)
    let session = NSURLSession.sharedSession()
    request.HTTPMethod = "POST"
    
    request.HTTPBody = jsonData
    
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    request.addValue("application/json", forHTTPHeaderField: "Accept")
    
    let task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
        print("Response: \(response)")
        print("Response String \(String(data: data!, encoding: NSUTF8StringEncoding))")
        
    })
    
    task.resume()
}

func returnResponseDictionary(response: Response, surveyResponse : SurveyResponse) -> NSDictionary
{
    let surveyResponseDictionary = NSMutableDictionary()
    /*let responseDictionary = NSMutableDictionary()
    responseDictionary.setValue(response.duration, forKey: "duration")
    responseDictionary.setValue(response.severity, forKey: "severity")
    responseDictionary.setValue(response.location, forKey: "location")
    responseDictionary.setValue(response.classification, forKey: "classification")*/
    
    surveyResponseDictionary.setValue(surveyResponse.__class__, forKey: "__class__")
    surveyResponseDictionary.setValue(NSUserDefaults.standardUserDefaults().objectForKey("UserId"), forKey: "userId")
    surveyResponseDictionary.setValue(surveyResponse.surveyId, forKey: "surveyId")
    surveyResponseDictionary.setValue(surveyResponse.timestamp, forKey: "timestamp")
    surveyResponseDictionary.setValue(response.duration, forKey: "duration")
    surveyResponseDictionary.setValue(response.severity, forKey: "severity")
    surveyResponseDictionary.setValue(response.location, forKey: "location")
    surveyResponseDictionary.setValue(response.classification, forKey: "classification")
    //surveyResponseDictionary.setValue(responseDictionary, forKey: "response")
    
    return surveyResponseDictionary
}
}