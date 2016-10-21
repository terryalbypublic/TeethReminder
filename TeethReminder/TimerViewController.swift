//
//  TimerViewController.swift
//  TeethReminder
//
//  Created by Alberti Terence on 11/05/16.
//  Copyright © 2016 TA. All rights reserved.
//

import UIKit

class TimerViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var timerView: TimerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timerView.startLoadAnimation()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(timerTapped))
        self.timerView.addGestureRecognizer(gesture)
        self.view.backgroundColor = Styles.tableViewBackgroundColor()
        self.timerView.backgroundColor = Styles.tableViewBackgroundColor()
        self.resetButton.isHidden=true

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.isIdleTimerDisabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func timerTapped() {
        if(timerView.isRunning){
            timerView.stopTimer()
            self.resetButton.isHidden=false
        }
        else if(timerView.isLoaded){
            timerView.startTimerAnimation()
            self.resetButton.isHidden=true
        }
    }
    
    @IBAction func resetButtonTapped(_ sender: AnyObject) {
        timerView.resetTimer()
        self.resetButton.isHidden = true
        
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
