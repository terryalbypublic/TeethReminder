//
//  HelpViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 08/03/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

open class HelpViewController: UIViewController {

    @IBOutlet open weak var closeButtonTapped: UIButton!
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func touchDownOkButton(_ sender: OkButtonView) {
        sender.highlight=true
        sender.setNeedsDisplay()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
