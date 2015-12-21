//
//  RemindersTableViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class GlobalConstants{
    
    static let userNotificationKey = "terence.keyForAllowedPush"
}

class RemindersTableViewController: UITableViewController {

    
    var reminderList = ReminderList.sharedInstance
    var reminders = Array<Reminder>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.SingleLine
        //self.tableView.separatorColor = UIColor.blueColor()
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        fillReminders()
        registerEventHandlerForPush()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func registerEventHandlerForPush(){
        
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "allowPushTapped",
            name: GlobalConstants.userNotificationKey,
            object: nil)
        
    }
    
    func allowPushTapped(){
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(false)
        self.tableView.reloadData()
    }
    
    func fillReminders(){
        reminderList.deserialize()
        reminders = reminderList.reminders
    }
    
    func setReminderActive(isActive: Bool, index: Int){
        reminders[index].isActive = isActive
        reminderList.serializeAndSave()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notificationsAllowed() ? reminders.count : (reminders.count + 1)
    }
    
    func notificationsAllowed() -> Bool{
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()!
        return settings.types.contains([.Alert, .Sound])
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // the last row is reserved for the warning (if the notifications are not allowed)
        if(indexPath.row == self.reminders.count){
            
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("WarningCell", forIndexPath: indexPath)
            
            return cell;
        }
        
        else{
            
            let cell : TableViewCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! TableViewCell

            cell.index = indexPath.row
            cell.name.text = reminders[indexPath.row].name
            cell.isActive.setOn(reminders[indexPath.row].isActive, animated: false)
            cell.time.text = reminders[indexPath.row].time()
        
            return cell
            
        }
    }
    
    
    override func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return "  Set the time of your reminders"
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(self.tableView.indexPathForSelectedRow != nil){
            
            let rowIndex = self.tableView.indexPathForSelectedRow?.row
            
            let reminder = ReminderList.sharedInstance.reminders[rowIndex!]
            
            let nextViewController = segue.destinationViewController as! SetTimeViewController
            nextViewController.reminder = reminder
            
        }
        
    }
    

}
