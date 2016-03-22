//
//  DashboardTableViewController.swift
//
//
//  Created by Krishnapillai, Bala on 2/9/16.
//
//

import UIKit

class DashboardTableViewController: UITableViewController {
    
    var Nobtnsendtag:UIButton!
    
    @IBAction func NextSteps(sender: AnyObject) {
        
        let eligibleCheck = NSUserDefaults.standardUserDefaults().valueForKey("1Q")!
        print("eligibleCheck\(eligibleCheck)")
        if (eligibleCheck as! String == "Yes")
        {
            performSegueWithIdentifier("EligibilityApprovedSegue", sender: self)
        }
        else{
            performSegueWithIdentifier("InEligibilitySegue", sender: self)
        }
        
    }
    
    @IBAction func BacktoHome(sender: AnyObject) {
        //performSegueWithIdentifier("EligiblitytoHome", sender: self)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        self.presentViewController((storyboard?.instantiateInitialViewController())!,animated:true, completion: nil)
        
        
    }
    //MARK: Properties
    
    var dashboards = [Dashboard]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        loadSampleData()
    }
    
    func loadSampleData()
    {
        //        let photo1 =  UIImage(named:"fitbit-icon")!
        //        let photo2 =  UIImage(named:"steps")!
        //        let photo3 =  UIImage(named:"map-marker-icon")!
        //        let photo4 =  UIImage(named:"calories")!
        //        let photo5 =  UIImage(named:"sleep")!
        //        let photo6 =  UIImage(named:"water")!
        
        
        let Dashboard1 = Dashboard(questions: "Are you over 18 and under 80 years old?", answers: "Yes", Noanswers: "No")!
        let Dashboard2 = Dashboard(questions: "Do you live in the United States of America?", answers: "Yes", Noanswers: "No")!
        let Dashboard3 = Dashboard(questions: "Are you comfortable reading and writing on your iPhone in English?", answers: "Yes", Noanswers: "No")!
        dashboards += [Dashboard1,Dashboard2,Dashboard3]
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return dashboards.count
    }
    
    func YesResponse(sender:UIButton!){
        var btnsendtag:UIButton = sender
        if btnsendtag.tag == 1 {
            print("0")
            NSUserDefaults.standardUserDefaults().setValue("Yes" as String, forKeyPath: "1Q")
            btnsendtag.setTitleColor(UIColor.blueColor(), forState:.Normal)
            
        }else if btnsendtag.tag == 3 {
            NSUserDefaults.standardUserDefaults().setValue("Yes" as String, forKeyPath: "2Q")
            print("1")
            btnsendtag.setTitleColor(UIColor.blueColor(), forState:.Normal)
            
        }else{
            print("2")
            NSUserDefaults.standardUserDefaults().setValue("Yes" as String, forKeyPath: "3Q")
            btnsendtag.setTitleColor(UIColor.blueColor(), forState:.Normal)
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        let otherButton = self.view.viewWithTag(btnsendtag.tag + 1) as? UIButton
        otherButton!.setTitleColor(UIColor.grayColor(), forState:.Normal)
        
    }
    
    
    
    func NoResponse(sender:UIButton!){
        let Nobtnsendtag:UIButton = sender
        if Nobtnsendtag.tag == 2 {
            print("0")
            NSUserDefaults.standardUserDefaults().setValue("No" as String, forKeyPath: "1Q")
            Nobtnsendtag.setTitleColor(UIColor.redColor(), forState:.Normal)
            
        }else if Nobtnsendtag.tag == 4 {
            NSUserDefaults.standardUserDefaults().setValue("No" as String, forKeyPath: "2Q")
            print("1")
            Nobtnsendtag.setTitleColor(UIColor.redColor(), forState:.Normal)
        }else{
            print("2")
            NSUserDefaults.standardUserDefaults().setValue("No" as String, forKeyPath: "3Q")
            Nobtnsendtag.setTitleColor(UIColor.redColor(), forState:.Normal)
            self.navigationItem.rightBarButtonItem?.enabled = true
        }
        
        let tagged = Nobtnsendtag.tag - 1;
        let otherButton = self.view.viewWithTag(tagged) as? UIButton
        otherButton!.setTitleColor(UIColor.grayColor(), forState:.Normal)
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "MyDeviceTableViewCell"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! MyTableViewCell
        let Dashboard = dashboards[indexPath.row]
        cell.Questions.text = Dashboard.questions
        cell.answers.text = Dashboard.answers
        cell.BtnYes.setTitle(Dashboard.answers, forState: .Normal)
        print("index.Path=\(indexPath.row)")
        cell.BtnYes.tag = (indexPath.row == 0 ? 1 : indexPath.row + 2)
        cell.BtnYes.addTarget(self, action: "YesResponse:", forControlEvents: UIControlEvents.TouchUpInside)
        cell.BtnNo.setTitle(Dashboard.Noanswers, forState: .Normal)
        cell.BtnNo.tag = cell.BtnYes.tag + 1
        cell.BtnNo.addTarget(self, action: "NoResponse:", forControlEvents: UIControlEvents.TouchUpInside)
        return cell
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
