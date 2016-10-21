//
//  Reminder.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

open class Reminder: NSObject {
    
    open var datetime : Date = Date()
    open var name : String = String()
    open var isActive : Bool = false
    let calendar = Calendar.current
    
    override public init(){
        super.init()
    }
    
    required public init(coder aDecoder: NSCoder) {
        datetime = aDecoder.decodeObject(forKey: "Datetime") as! Date
        name = aDecoder.decodeObject(forKey: "Name") as! String
        isActive = aDecoder.decodeBool(forKey: "IsActive")
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(isActive, forKey: "IsActive")
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(datetime, forKey: "Datetime")
    }
    
    open func time() ->String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: datetime)
    }
}


open class ReminderList: NSObject{
    
    open static let sharedInstance = ReminderList()
    open var reminders : Array<Reminder> = []
    
    open func setInitialValues(){
        
        self.deserialize()
        
        if(reminders.count > 0){
            return;
        }
        
        let reminder1 = Reminder()
        
        let calendar = Calendar.current
        var datecomponents = DateComponents()
        
        
        datecomponents.minute = 0
        datecomponents.hour = 8
        
        reminder1.datetime = calendar.date(from: datecomponents)!
        reminder1.name = "Reminder for the Morning"
        reminder1.isActive = false
        
        let reminder2 = Reminder()
        
        datecomponents.minute = 0
        datecomponents.hour = 13
        
        reminder2.datetime = calendar.date(from: datecomponents)!
        reminder2.name = "Reminder for the Afternoon"
        reminder2.isActive = false
        
        let reminder3 = Reminder()
        
        datecomponents.minute = 0
        datecomponents.hour = 21
        
        reminder3.datetime = calendar.date(from: datecomponents)!
        reminder3.name = "Reminder for the Evening"
        reminder3.isActive = false
        
        self.reminders.append(reminder1)
        self.reminders.append(reminder2)
        self.reminders.append(reminder3)
        
        serializeAndSave()
        
    }
    

    
    open func deserialize(){
        
        // read from nsuserdefaults
        let userdata = UserDefaults.standard
        let data = userdata.data(forKey: "userdata")
        
        if(data != nil){
            reminders = NSKeyedUnarchiver.unarchiveObject(with: data!) as! Array<Reminder>
        }
        else{
            reminders = Array<Reminder>();
        }
    }
    
    open func serializeAndSave(){
        let data = NSKeyedArchiver.archivedData(withRootObject: reminders)
        let defaults = UserDefaults.standard
        defaults.set(data, forKey: "userdata")
        
        // remove all old scheduled notifications
        UIApplication.shared.cancelAllLocalNotifications()
        
        // add the new one
        for reminder in reminders{
            if(reminder.isActive){
                let localNotification = UILocalNotification()
                localNotification.fireDate = reminder.datetime
                localNotification.alertBody = "Let brush your teeth !!!"
                localNotification.repeatInterval = .day
                localNotification.timeZone = TimeZone.current
                localNotification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
                
                UIApplication.shared.scheduleLocalNotification(localNotification)
            }
        }
        
    }
    
    
}
