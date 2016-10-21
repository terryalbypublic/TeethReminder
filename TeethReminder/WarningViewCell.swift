//
//  WarningViewCell.swift
//  TeethReminder
//
//  Created by Alberti Terence on 29/04/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class WarningViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        backgroundColor = Styles.tableViewBackgroundColor()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
