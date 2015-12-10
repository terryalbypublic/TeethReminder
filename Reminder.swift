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
        reminder1.name = "Reminder1"
        reminder1.isActive = false
        
        let reminder2 = Reminder()
        
        reminder2.datetime = NSDate()
        reminder2.name = "Reminder2"
        reminder2.isActive = false
        
        let reminder3 = Reminder()
        
        reminder3.datetime = NSDate()
        reminder3.name = "Reminder3"
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
    }
    
    
}
