//
//  TableViewCell.swift
//  TeethReminder
//
//  Created by Alberti Terence on 07/12/15.
//  Copyright © 2015 TA. All rights reserved.
//

import UIKit

public class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var isActive: UISwitch!
    public var index  : Int = 0
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // ui switch bigger (30% more)
        isActive.transform = CGAffineTransformMakeScale(1.3, 1.3);
        backgroundColor = UIColor(red: 33/255, green: 134/255, blue: 239/255, alpha: 1)
        
    }

    public override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func switchButtonTapped(sender: AnyObject) {
        ReminderList.sharedInstance.reminders[index].isActive = isActive.on
        ReminderList.sharedInstance.serializeAndSave()
    }
}
