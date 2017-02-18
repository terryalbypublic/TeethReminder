//
//  RemindersTableViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit
import Firebase

open class GlobalConstants{
    
    static let userNotificationKey = "terence.keyForAllowedPush"
}

open class RemindersTableViewController: UITableViewController {

    var helpViewController = HelpViewController()
    var timeViewController = SetTimeViewController()
    var reminderList = ReminderList.sharedInstance
    var reminders = Array<Reminder>()
    var isHelpViewOpen = false
    var isTimeViewOpen = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Styles.tableViewBackgroundColor()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        self.navigationController?.navigationBar.barTintColor = Styles.tableViewBackgroundColor()
        self.navigationController?.navigationBar.barTintColor = Styles.navigationBackgroundColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Styles.fontColor(.blue)]
        
        fillReminders()
        
        if(!notificationsAllowed()){
            registerEventHandlerForPush()
        }
    }
    
    
    @IBAction func helpButtonTapped(_ sender: AnyObject) {
        if(!isHelpViewOpen && !isTimeViewOpen){
            isHelpViewOpen = true
            self.helpViewController = getHelpViewController() as! HelpViewController
            self.navigationController!.view.addSubview(helpViewController.view)
            helpViewController.closeButtonTapped.addTarget(self, action: #selector(RemindersTableViewController.closeHelpView(_:)), for: UIControlEvents.touchUpInside)
            self.animateOpenView(self.helpViewController.view)
        }
    }
    
    fileprivate func openTimeView(_ row: Int){
        if(!isHelpViewOpen && !isTimeViewOpen){
            isTimeViewOpen = true
            self.timeViewController = getTimeViewController() as! SetTimeViewController
            let reminder = ReminderList.sharedInstance.reminders[row]
            self.timeViewController.reminder = reminder
            self.timeViewController.refresh()
            self.navigationController!.view.addSubview(timeViewController.view)
            timeViewController.saveButton.addTarget(self, action: #selector(RemindersTableViewController.closeTimeView(_:)), for: UIControlEvents.touchUpInside)
            self.animateOpenView(self.timeViewController.view)
        }
    }
    
    
    func animateOpenView(_ view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 0.5;
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        let scale = CGAffineTransform(scaleX: 0.3, y: 0.3)
        let translate = CGAffineTransform(translationX: 50, y: -50)
        view.transform = scale.concatenating(translate)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.5, animations: {
            let scale = CGAffineTransform(scaleX: 1,y: 1)
            let translate = CGAffineTransform(translationX: 0, y: 0)
            view.transform = scale.concatenating(translate)
            view.alpha = 1
        })
    }
    
    func animateCloseView(_ view: UIView){
        UIView.animate(withDuration: 0.5, animations: {
            self.view.alpha = 1;
            self.view.transform = CGAffineTransform(translationX: 0, y: 0)
        })
    }
    
    func closeHelpView(_ sender: AnyObject){
        isHelpViewOpen = false
        self.animateCloseView(self.helpViewController.view)
        self.helpViewController.view.removeFromSuperview()
    }
    
    open func closeTimeView(_ sender: AnyObject){
        isTimeViewOpen = false
        self.timeViewController.saveButtonTapped(sender)
        self.animateCloseView(self.timeViewController.view)
        self.timeViewController.view.removeFromSuperview()
        self.tableView.reloadData()
    }
    
    func getHelpViewController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let helpViewCtr = storyboard.instantiateViewController(withIdentifier: "HelpViewController") as UIViewController
        
        if(CurrentDevice.device.modelName == "iPhone 4s"){
            helpViewCtr.view.frame = CGRect(x: self.view.frame.width * 0.05 , y: 100, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.52)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5"){
            helpViewCtr.view.frame = CGRect(x: self.view.frame.width * 0.05 , y: 100, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.45)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5s"){
            helpViewCtr.view.frame = CGRect(x: self.view.frame.width * 0.05 , y: 100, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.45)
        }
        else{
           helpViewCtr.view.frame = CGRect(x: self.view.frame.width * 0.05 , y: 100, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.35)
        }
        
        helpViewCtr.view.layer.cornerRadius = 5
        return helpViewCtr
    }
    
    // handler used for the first app start, when the user accepts (or refuse) to allow notifications
    func registerEventHandlerForPush(){
        // if the user tap on allow notifications, the method allowPushTapped is called
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(RemindersTableViewController.allowPushTapped),
            name: NSNotification.Name(rawValue: GlobalConstants.userNotificationKey),
            object: nil)
        
    }
    
    // the user allowed to receive push
    func allowPushTapped(){
        self.tableView.reloadData()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        // tracking
        FIRAnalytics.logEvent(withName: kFIREventSelectContent, parameters: [
            kFIRParameterItemName: "openRemindersView" as NSObject
            ])
        
        self.tableView.reloadData()
    }
    
    func fillReminders(){
        reminderList.deserialize()
        reminders = reminderList.reminders
    }
    
    func setReminderActive(_ isActive: Bool, index: Int){
        reminders[index].isActive = isActive
        reminderList.serializeAndSave()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Styles.tableViewCellHeight();
    }

    override open func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return notificationsAllowed() ? reminders.count : (reminders.count + 1)
    }
    
    func notificationsAllowed() -> Bool{
        let settings = UIApplication.shared.currentUserNotificationSettings!
        return settings.types.contains([.alert, .sound])
    }

    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // the last row is reserved for the warning (if the notifications are not allowed)
        if((indexPath as NSIndexPath).row == self.reminders.count){
            
            let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "WarningCell", for: indexPath)
            return cell;
        }
        
        else{
            
            let cell : ReminderViewCell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell", for: indexPath) as! ReminderViewCell

            cell.index = indexPath.row
            cell.name.text = reminders[indexPath.row].name
            cell.isActive.setOn(reminders[indexPath.row].isActive, animated: false)
            cell.isActiveLabel.text = reminders[indexPath.row].isActive ? "On" : "Off"
            cell.time.text = reminders[indexPath.row].time()
        
            return cell
            
        }
    }
    
    
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // if the user selected the cell with the warning
        if((indexPath as NSIndexPath).row == 3){
            return;
        }
        
        openTimeView((indexPath as NSIndexPath).row)
        
    }
    
    func getTimeViewController() -> UIViewController{
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let timeViewCtr = storyboard.instantiateViewController(withIdentifier: "SetTimeViewController") as UIViewController
        
        if(CurrentDevice.device.modelName == "iPhone 4s"){
            timeViewCtr.view.frame = CGRect(x: 0 , y: 100, width: self.view.frame.width, height: self.view.frame.height * 0.6)
        }
        else if(CurrentDevice.device.modelName == "iPhone 5"){
            timeViewCtr.view.frame = CGRect(x: 0 , y: 100, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        }
        
        else if(CurrentDevice.device.modelName  == "iPhone 5s"){
            timeViewCtr.view.frame = CGRect(x: 0 , y: 100, width: self.view.frame.width, height: self.view.frame.height * 0.5)
        }
        else if(CurrentDevice.device.modelName  == "iPhone 6"){
            timeViewCtr.view.frame = CGRect(x: 0 , y: 100, width: self.view.frame.width, height: self.view.frame.height * 0.46)
        }
        else if(CurrentDevice.device.modelName  == "iPhone 6s"){
            timeViewCtr.view.frame = CGRect(x: 0 , y: 100, width: self.view.frame.width, height: self.view.frame.height * 0.46)
        }
        else{
            timeViewCtr.view.frame = CGRect(x: self.view.frame.width * 0.05 , y: 100, width: self.view.frame.width * 0.9, height: self.view.frame.height * 0.4)
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
