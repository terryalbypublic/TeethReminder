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

public class RemindersTableViewController: UITableViewController {

    var helpViewController = HelpViewController()
    var timeViewController = SetTimeViewController()
    var reminderList = ReminderList.sharedInstance
    var reminders = Array<Reminder>()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Styles.tableViewBackgroundColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        self.navigationController?.navigationBar.barTintColor = Styles.tableViewBackgroundColor()
        self.navigationController?.navigationBar.barTintColor = Styles.navigationBackgroundColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Styles.fontColor(.Blue)]
        
        fillReminders()
        
        if(!notificationsAllowed()){
            registerEventHandlerForPush()
        }
    }
    
    @IBAction func helpButtonTapped(sender: AnyObject) {
        self.helpViewController = getHelpViewController() as! HelpViewController
        self.navigationController!.view.addSubview(helpViewController.view)
        helpViewController.closeButtonTapped.addTarget(self, action: "closeHelpView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.animateOpenView(self.helpViewController.view)
    }
    
    
    func animateOpenView(view: UIView){
        UIView.animateWithDuration(0.5, animations: {
            self.view.alpha = 0.5;
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        let scale = CGAffineTransformMakeScale(0.3, 0.3)
        let translate = CGAffineTransformMakeTranslation(50, -50)
        view.transform = CGAffineTransformConcat(scale, translate)
        view.alpha = 0
        
        UIView.animateWithDuration(0.5, animations: {
            let scale = CGAffineTransformMakeScale(1,1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            view.transform = CGAffineTransformConcat(scale, translate)
            view.alpha = 1
        })
    }
    
    func animateCloseView(view: UIView){
        UIView.animateWithDuration(0.5, animations: {
            self.view.alpha = 1;
            self.view.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
    func closeHelpView(sender: AnyObject){
        self.animateCloseView(self.helpViewController.view)
        self.helpViewController.view.removeFromSuperview()
    }
    
    public func closeTimeView(sender: AnyObject){
        self.timeViewController.saveButtonTapped(sender)
        self.animateCloseView(self.timeViewController.view)
        self.timeViewController.view.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    func getHelpViewController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let helpViewCtr = storyboard.instantiateViewControllerWithIdentifier("HelpViewController") as UIViewController
        
        if(CurrentDevice.device.modelName == "iPhone 4s"){
            helpViewCtr.view.frame = CGRectMake(self.view.frame.width * 0.05 , 100, self.view.frame.width * 0.9, self.view.frame.height * 0.52)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5"){
            helpViewCtr.view.frame = CGRectMake(self.view.frame.width * 0.05 , 100, self.view.frame.width * 0.9, self.view.frame.height * 0.45)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5s"){
            helpViewCtr.view.frame = CGRectMake(self.view.frame.width * 0.05 , 100, self.view.frame.width * 0.9, self.view.frame.height * 0.45)
        }
        else{
           helpViewCtr.view.frame = CGRectMake(self.view.frame.width * 0.05 , 100, self.view.frame.width * 0.9, self.view.frame.height * 0.35)
        }
        
        helpViewCtr.view.layer.cornerRadius = 5
        return helpViewCtr
    }
    
    // handler used for the first app start, when the user accepts (or refuse) to allow notifications
    func registerEventHandlerForPush(){
        // if the user tap on allow notifications, the method allowPushTapped is called
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: "allowPushTapped",
            name: GlobalConstants.userNotificationKey,
            object: nil)
        
    }
    
    // the user allowed to receive push
    func allowPushTapped(){
        self.tableView.reloadData()
    }
    
    override public func viewWillAppear(animated: Bool) {
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

    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Styles.tableViewCellHeight();
    }

    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notificationsAllowed() ? reminders.count : (reminders.count + 1)
    }
    
    func notificationsAllowed() -> Bool{
        let settings = UIApplication.sharedApplication().currentUserNotificationSettings()!
        return settings.types.contains([.Alert, .Sound])
    }

    
    override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // the last row is reserved for the warning (if the notifications are not allowed)
        if(indexPath.row == self.reminders.count){
            
            let cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("WarningCell", forIndexPath: indexPath)
            return cell;
        }
        
        else{
            
            let cell : ReminderViewCell = tableView.dequeueReusableCellWithIdentifier("ReminderCell", forIndexPath: indexPath) as! ReminderViewCell

            cell.index = indexPath.row
            cell.name.text = reminders[indexPath.row].name
            cell.isActive.setOn(reminders[indexPath.row].isActive, animated: false)
            cell.isActiveLabel.text = reminders[indexPath.row].isActive ? "On" : "Off"
            cell.time.text = reminders[indexPath.row].time()
        
            return cell
            
        }
    }
    
    
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // if the user selected the cell with the warning
        if(indexPath.row == 3){
            return;
        }
        
        self.timeViewController = getTimeViewController() as! SetTimeViewController
        let rowIndex = self.tableView.indexPathForSelectedRow?.row
        let reminder = ReminderList.sharedInstance.reminders[rowIndex!]
        self.timeViewController.reminder = reminder
        self.timeViewController.refresh()
        self.navigationController!.view.addSubview(timeViewController.view)
        timeViewController.saveButton.addTarget(self, action: "closeTimeView:", forControlEvents: UIControlEvents.TouchUpInside)
        self.animateOpenView(self.timeViewController.view)
    }
    
    func getTimeViewController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timeViewCtr = storyboard.instantiateViewControllerWithIdentifier("SetTimeViewController") as UIViewController
        
        if(CurrentDevice.device.modelName == "iPhone 4s"){
            timeViewCtr.view.frame = CGRectMake(0 , 100, self.view.frame.width, self.view.frame.height * 0.6)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5"){
            timeViewCtr.view.frame = CGRectMake(0 , 100, self.view.frame.width, self.view.frame.height * 0.5)
        }
        
        else if(CurrentDevice.device.modelName  == "iPhone 5s"){
            timeViewCtr.view.frame = CGRectMake(0 , 100, self.view.frame.width, self.view.frame.height * 0.5)
        }
        else if(CurrentDevice.device.modelName  == "iPhone 6"){
            timeViewCtr.view.frame = CGRectMake(0 , 100, self.view.frame.width, self.view.frame.height * 0.46)
        }
        else if(CurrentDevice.device.modelName  == "iPhone 6s"){
            timeViewCtr.view.frame = CGRectMake(0 , 100, self.view.frame.width, self.view.frame.height * 0.46)
        }
        else{
            timeViewCtr.view.frame = CGRectMake(self.view.frame.width * 0.05 , 100, self.view.frame.width * 0.9, self.view.frame.height * 0.4)
        }
        
        timeViewCtr.view.layer.cornerRadius = 5
        return timeViewCtr
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

    

}
