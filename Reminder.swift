//
//  Reminder.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class Reminder: NSObject {
    
    public var datetime : NSDate
    public var name : String
    public var isActive : Bool
    
    override init(){
        datetime = NSDate()
        name = "Reminder 1"
        isActive = true
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
    
    public var reminders : Array<Reminder> = []
    
    
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
