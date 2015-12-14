//
//  Reminder.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class Reminder: NSObject {
    
    public var datetime : NSDate = NSDate()
    public var name : String = String()
    public var isActive : Bool = false
    let calendar = NSCalendar.currentCalendar()
    
    override public init(){
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        datetime = aDecoder.decodeObjectForKey("Datetime") as! NSDate
        name = aDecoder.decodeObjectForKey("Name") as! String
        isActive = aDecoder.decodeBoolForKey("IsActive")
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeBool(isActive, forKey: "IsActive")
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(datetime, forKey: "Datetime")
    }
    
    public func time() ->String{
        let date = self.datetime
        let components = calendar.components([.Hour, .Minute], fromDate: date)
        
        var zero = ""
        
        if(components.minute<10){
            zero = "0"
        }
        
        
        return String(components.hour)+":"+zero+String(components.minute)
    }
}


public class ReminderList: NSObject{
    
    public static let sharedInstance = ReminderList()
    public var reminders : Array<Reminder> = []
    
    public func setInitialValues(){
        
        self.deserialize()
        
        if(reminders.count > 0){
            return;
        }
        
        let reminder1 = Reminder()
        
        reminder1.datetime = NSDate()
        reminder1.name = "Reminder for the Morning"
        reminder1.isActive = false
        
        let reminder2 = Reminder()
        
        reminder2.datetime = NSDate()
        reminder2.name = "Reminder for the Afternoon"
        reminder2.isActive = false
        
        let reminder3 = Reminder()
        
        reminder3.datetime = NSDate()
        reminder3.name = "Reminder for the Evening"
        reminder3.isActive = false
        
        self.reminders.append(reminder1)
        self.reminders.append(reminder2)
        self.reminders.append(reminder3)
        
        serializeAndSave()
        
    }
    

    
    public func deserialize(){
        
        // read from nsuserdefaults
        let userdata = NSUserDefaults.standardUserDefaults()
        let data = userdata.dataForKey("userdata")
        
        if(data != nil){
            reminders = NSKeyedUnarchiver.unarchiveObjectWithData(data!) as! Array<Reminder>
        }
        else{
            reminders = Array<Reminder>();
        }
    }
    
    public func serializeAndSave(){
        let data = NSKeyedArchiver.archivedDataWithRootObject(reminders)
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(data, forKey: "userdata")
        
        // remove all old scheduled notifications
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        
        // add the new one
        for reminder in reminders{
            if(reminder.isActive){
                let localNotification = UILocalNotification()
                localNotification.fireDate = reminder.datetime
                localNotification.alertBody = "Let brush your teeth !!!"
                localNotification.repeatInterval = .Day
                localNotification.timeZone = NSTimeZone.defaultTimeZone()
                localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
                
                UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            }
        }
        
    }
    
    
}
