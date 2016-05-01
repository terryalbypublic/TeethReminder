//
//  TableViewCell.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class ReminderViewCell: UITableViewCell {
    
    @IBOutlet weak var isActiveLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isActive: UISwitch!
    public var index  : Int = 0
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // ui switch bigger (30% more)
        isActive.transform = CGAffineTransformMakeScale(1.6, 1.6)
        backgroundColor = Styles.tableViewBackgroundColor()
        
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func OnOffButtonTapped(sender: AnyObject) {
        self.isActive.setOn(!self.isActive.on, animated: true)
        switchButtonTapped(sender)
    }
    
    @IBAction func switchButtonTapped(sender: AnyObject) {
        
        ReminderList.sharedInstance.reminders[index].isActive = isActive.on
        self.isActiveLabel.text = ReminderList.sharedInstance.reminders[index].isActive ? "On" : "Off"
        ReminderList.sharedInstance.serializeAndSave()
    }
}
