//
//  GraphsTableViewController.swift
//  myHeart
//
//  Created by Shashank Kothapalli on 8/25/15.
//  Copyright (c) 2015 Amgen. All rights reserved.
//

import UIKit

class GraphsTableViewController: UITableViewController {

    let healthManager:HealthKit = HealthKit()
    let graphs = ["Steps","Heart Rate"]
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return graphs.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        cell.textLabel?.text = graphs[indexPath.row]
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.row {
            case 0:
                self.healthManager.readSteps()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    let storyboard = UIStoryboard(name: "Main", bundle:nil)
                    let stepsView = storyboard.instantiateViewControllerWithIdentifier("StepsView") as! UIViewController
                    self.presentViewController(stepsView, animated: true, completion: nil)
                })
            case 1:
                self.healthManager.readHeartRate()
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(3 * Double(NSEC_PER_SEC))), dispatch_get_main_queue(), {
                    let storyboard = UIStoryboard(name: "Main", bundle:nil)
                    let stepsView = storyboard.instantiateViewControllerWithIdentifier("HeartView") as! UIViewController
                    self.presentViewController(stepsView, animated: true, completion: nil)
                })
            
            default:
                break
        }
    }

}
