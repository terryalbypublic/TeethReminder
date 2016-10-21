//
//  TableViewCell.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

open class ReminderViewCell: UITableViewCell {
    
    @IBOutlet weak var isActiveLabel: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isActive: UISwitch!
    open var index  : Int = 0
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // ui switch bigger (30% more)
        isActive.transform = CGAffineTransform(scaleX: 1.6, y: 1.6)
        backgroundColor = Styles.tableViewBackgroundColor()
        
    }

    open override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func OnOffButtonTapped(_ sender: AnyObject) {
        self.isActive.setOn(!self.isActive.isOn, animated: true)
        switchButtonTapped(sender)
    }
    
    @IBAction func switchButtonTapped(_ sender: AnyObject) {
        
        ReminderList.sharedInstance.reminders[index].isActive = isActive.isOn
        self.isActiveLabel.text = ReminderList.sharedInstance.reminders[index].isActive ? "On" : "Off"
        ReminderList.sharedInstance.serializeAndSave()
    }
}
